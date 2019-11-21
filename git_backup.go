package main

import (
	"flag"
	"fmt"
	"log"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
)

func exists(path string) (bool, error) {
	_, err := os.Stat(path)
	if err == nil {
		return true, nil
	}
	if os.IsNotExist(err) {
		return false, nil
	}
	return true, err
}

func path_depth(path string) int {
	return len(strings.Split(filepath.ToSlash(path), "/"))
}

func FindGitRepos(root string, depth_limit int) ([]string, error) {
	var files []string
	root_depth := path_depth(root)
	err := filepath.Walk(root, func(path string, info os.FileInfo, err error) error {
		if err == nil {
			if info.IsDir() {
				is_dir, _ := exists(filepath.Join(path, ".git"))
				if is_dir {
					if (path_depth(path) - root_depth) < depth_limit {
						files = append(files, path)
					}
				}
			}
		}
		return nil
	})
	return files, err
}

func BackupGitRepos(repo_paths []string, source string, destination string) (bool, error) {
	backups := make(chan string, len(repo_paths))
	for _, path := range repo_paths {
		backups <- path
		BackupGitRepo(<-backups, source, destination)
	}
	return true, nil
}

func GitCloneRepo(repo_path string, dest_path string) error {
	cmd := exec.Command("git", "clone", "--bare", repo_path, dest_path)
	return cmd.Run()
}

func GitFetchRepo(repo_path string, dest_path string) error {
	cmd := exec.Command("git", "fetch", repo_path)
	cmd.Dir = dest_path
	return cmd.Run()
}

func BackupGitRepo(repo_path string, source string, destination string) (bool, error) {
	rel_path, _ := filepath.Rel(source, repo_path)
	dest_path := filepath.Join(destination, rel_path)
	is_dir, _ := exists(dest_path)
	var backuperror error
	backup_method := "Fetch"
	if is_dir {
		backuperror = GitFetchRepo(repo_path, dest_path)
	} else {
		backuperror = GitCloneRepo(repo_path, dest_path)
		backup_method = "Clone"
	}
	if backuperror != nil {
		log.Fatalf("%v backup of %v to %v failed with error: %v\n", backup_method, repo_path, dest_path, backuperror)
		return false, backuperror
	} else {
		fmt.Printf("Backed up %v to %v.\n", repo_path, dest_path)
		return true, nil
	}
}

func main() {
	source := flag.String("source", "./", "Path to search for git repositories")
	destination := flag.String("dest", "./backups", "Path to save copies of repositories")
	depth := flag.Int("depth", 100, "Path depth limit")
	flag.Parse()
	repos, err := FindGitRepos(*source, *depth)
	if err != nil {
		log.Fatal(err)
	}
	BackupGitRepos(repos, *source, *destination)
}
