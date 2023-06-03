// Get/Set the prompt.
let prompt = Deno.args.join(" ")
if (prompt == "") {
  prompt = "Proceed?"
}

if (!confirm(prompt)) {
  Deno.exit(1)
}

