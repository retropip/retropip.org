const jsonUrl = (pack) => `https://pypi.org/pypi/${pack}/json`;

const html = (pack, links) => `
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title>Links for ${pack}</title>
  </head>
  <body>
    <h1>Links for ${pack}</h1>
    ${links.map((link) => `<!-- ${link.date} -->\n<a href="${link.url}#${link.sha256}">${link.name}</a>`).join('\n')}
  </body>
</html>
`;

function generateLinks(json) {
  return Object.values(json.releases)
    .flatMap((r) => {
      return r.map((release) => {
        return {
          name: release.filename,
          url: release.url,
          sha256: release.digests.sha256,
          date: new Date(release.upload_time),
        };
      });
  });
}

function filterLinks(cutoff) {
  return (links) => {
    return links.filter((link) => link.date < cutoff);
  };
}

// to run locally comment out export keyword
export async function onRequestGet(context) {
  const pack = context.params.package;
  const year = context.params.year;
  const month = context.params.month;
  const day = context.params.day;

  const cutoff = new Date(year, month - 1, day);
  //TODO: validate if the date is valid

  const res = await fetch(jsonUrl(pack));
  if (!res.ok) {
    const stat = res.status;
    return new Response(`Error fetching json: ${stat}`, { status: stat });
  }

  const json = await res.json();
  const links = generateLinks(json).filter(filterLinks(cutoff));

  return new Response(html(pack, links), {
    headers: {
      'content-type': 'text/html',
    },
  });
}

// to run locally and testing pruposes
if (require.main === module) {
  date = new Date(process.argv[3]);
  fetch(jsonUrl(process.argv[2]))
    .then((res) => {
      if (res.ok) {
        return res.json();
      }
      throw new Error('Error fetching json');
    })
    .then(generateLinks)
    .then(filterLinks(date))
    .then((links) => {
      console.log(html(process.argv[2], links));
    });
}
