// git_backup finds git repositories under a source directory and backs up
// each one as a bare repository under a destination directory.
//
// On the first run, the tool clones each repository. On later runs, it
// fetches new changes into the existing bare copy instead of cloning again.
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

// exists reports if a path is present on disk. If the stat call fails for a
// reason other than "not found", exists returns true along with the error.
// This tells the caller not to treat the path as absent.
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

// path_depth counts the segments in a path. It converts the path to forward
// slashes first, so the count is the same on every OS.
func path_depth(path string) int {
	return len(strings.Split(filepath.ToSlash(path), "/"))
}

// FindGitRepos walks the directory tree under root and returns the path of
// every directory that contains a .git entry.
//
// depth_limit counts path segments below root, not below the repository
// above it. A repository at or beyond depth_limit segments below root is
// skipped.
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

// BackupGitRepos backs up each repository in repo_paths, one at a time. It
// passes each path through a channel, but it does not back up repositories
// concurrently.
func BackupGitRepos(repo_paths []string, source string, destination string) (bool, error) {
	backups := make(chan string, len(repo_paths))
	for _, path := range repo_paths {
		backups <- path
		BackupGitRepo(<-backups, source, destination)
	}
	return true, nil
}

// GitCloneRepo makes a new bare clone of repo_path at dest_path.
func GitCloneRepo(repo_path string, dest_path string) error {
	cmd := exec.Command("git", "clone", "--bare", repo_path, dest_path)
	return cmd.Run()
}

// GitFetchRepo fetches from repo_path into the existing bare repository at
// dest_path.
func GitFetchRepo(repo_path string, dest_path string) error {
	cmd := exec.Command("git", "fetch", repo_path)
	cmd.Dir = dest_path
	return cmd.Run()
}

// BackupGitRepo backs up one repository. It clones repo_path if dest_path
// does not exist yet. It fetches into dest_path if dest_path already
// exists.
//
// If the backup fails, BackupGitRepo logs the error and exits the program.
// It does not return the error to the caller.
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

// main reads the command line flags, finds repositories under source, and
// backs up each one to destination.
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
