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
  const cutoff = Date(`${context.param.year}-${context.param.month}-${context.param.day}`);
  const pythonpackageIndex = await fetch(JSON_URL.replace('{package}', context.param.package)).then(response => response.json());
  let releaseLinks = '';
  for (const release of Object.values(pythonpackageIndex.releases)) {
    for (const file of release) {
      const releaseDate = parseIso(file.upload_time);
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
  return new Response(PACKAGE_HTML.replace('{pythonpackage}', package).replace('{links}', releaseLinks));
}
