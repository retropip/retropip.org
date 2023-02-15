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
    let content = await response.text();
    // Replace all instances of href="/simple/..." prepending the year, month and day parts inside `context.param`. Use replaceAll()
    let newContent = content.replaceAll('href="/simple/', `href="/${context.params.year}/${context.params.month}/${context.params.day}/simple/`);
    return new Response(newContent, { headers });
  }
}

