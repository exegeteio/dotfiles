// Get/Set the location to watch.
if (Deno.args.length < 2) {
  console.log("%cMust specify a location and command!", "color: red;");
  Deno.exit(1);
}

let location: string = Deno.args[0];
if (location === undefined) {
  console.log("%cMust specify a location to watch!", "color: red;");
}
// Try to stat the location to see if it exists or not.
try {
  let locationStat = Deno.statSync(location);
} catch (error) {
  console.error(`%cUnable to open "${location}":\n${error}`, "color: red;");
  Deno.exit(1);
}

const command: string[] = Deno.args.slice(1, Deno.args.length);
console.log(`Watching "${location}" and running "${command.join(" ")}"`);

const watcher = Deno.watchFs(location);
for await (const event of watcher) {
  if (event.kind != "remove") {
    for (const path of event.paths) {
      const locationStat = Deno.statSync(path);
      if (locationStat.mtime == localStorage.getItem(path)) {
        continue;
      } else {
        localStorage.setItem(path, locationStat.mtime);
      }
    }
  }
  console.log(`%c${event.kind} -- ${event.paths.join(", ")}`, "color: yellow;");
  let p: Deno.Process;
  try {
    p = Deno.run({ cmd: command });
  } catch (error) {
    // Not being able to find the command is unrecoverable.
    console.error(`%cUnable to execute "${command}":\n${error}`, "color: red;");
    Deno.exit(1);
  }
  const status = await p.status();
  let css = "color: red;";
  if (status.success) {
    css = "color: green;";
  }
  console.log(`%cExit Code:  ${status.code}`, css);
}
