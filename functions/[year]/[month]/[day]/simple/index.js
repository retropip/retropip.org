/*
 * Return the same output as pypi /simple/ html interface.
 */
export async function onRequestGet(context) {
  // Request pypi's /simple/ package index
  const response = await fetch("https://pypi.org/simple/");
  if (response.ok) {
    let headers = new Headers({
        'Content-Type': 'text/html'
    });
    return new Response(await response.text(), { headers });
  }
}

