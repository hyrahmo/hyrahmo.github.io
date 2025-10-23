// Simple client-side language switcher that navigates to /en/ or / (ru)
document.getElementById('lang-ru')?.addEventListener('click', function(e){
  e.preventDefault();
  // if already on en path, navigate back to root equivalent
  const p = location.pathname;
  if (p.startsWith('/en/')) {
    const newp = p.replace('/en','') || '/';
    location.pathname = newp;
  } else {
    // already ru - reload to keep same page
    location.reload();
  }
});
document.getElementById('lang-en')?.addEventListener('click', function(e){
  e.preventDefault();
  const p = location.pathname;
  if (p.startsWith('/en/')) return;
  // map to /en/ equivalent: /about -> /en/about
  const newp = '/en' + (p === '/' ? '/' : p);
  location.pathname = newp;
});
