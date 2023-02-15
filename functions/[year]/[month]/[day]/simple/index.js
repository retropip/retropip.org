/*
 * Return the same output as pypi /simple/ html interface.
 */
export function onRequest(context) {
  return new Response(context.params.year)
}

