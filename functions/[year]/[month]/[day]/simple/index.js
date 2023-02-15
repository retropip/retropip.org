/*
 * Return the same output as pypi /simple/ html interface.
 */
export function onRequestGet(context) {
  // Request pypi's /simple/ package index
  const response = await fetch("https://pypi.org/simple/");
  if (response.ok) {
    return new Response(await response.text());
  }
}

