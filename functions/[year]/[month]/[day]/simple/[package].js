const JSON_URL = 'https://pypi.org/pypi/{pythonpackage}/json';

const PACKAGE_HTML = `
<!DOCTYPE html>
<html>
  <head>
    <title>Links for {pythonpackage}</title>
  </head>
  <body>
    <h1>Links for {pythonpackage}</h1>
{links}
  </body>
</html>
`;

function parseIso(dt) {
  return new Date(dt);
}

/*
 * 
 */
export async function onRequestGet(context) {
  const cutoff = parseIso(`${context.params.year}-${context.params.month}-${context.params.day}T00:00:00`);
  console.log(cutoff);
  const response = await fetch(JSON_URL.replace('{pythonpackage}', context.params.package));
  if (!response.ok) {
    return new Response("not found", { status: 404 });
  }
  const packageIndex = await response.json();
  let releaseLinks = '';
  for (const release of Object.values(packageIndex.releases)) {
    for (const file of release) {
      const releaseDate = parseIso(file.upload_time);
      console.log(releaseDate);
      if (releaseDate < cutoff) {
        if (file.requires_python === null) {
          releaseLinks += `    <a href="${file.url}#sha256=${file.digests.sha256}">${file.filename}</a><br/>\n`;
        } else {
          const rp = file.requires_python.replace('>', '&gt;');
          releaseLinks += `    <a href="${file.url}#sha256=${file.digests.sha256}" data-requires-python="${rp}">${file.filename}</a><br/>\n`;
        }
      }
    }
  }
  let headers = new Headers({
      'Content-Type': 'text/html'
  });
  return new Response(PACKAGE_HTML.replaceAll('{pythonpackage}', context.params.package).replace('{links}', releaseLinks), { headers });
}
