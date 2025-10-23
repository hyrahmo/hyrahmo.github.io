// Simple theme toggle using localStorage
(function(){
  const btn = document.getElementById('theme-toggle');
  const root = document.documentElement;
  const init = () => {
    const theme = localStorage.getItem('theme') || 'light';
    document.body.setAttribute('data-theme', theme);
  };
  init();
  if (btn) btn.addEventListener('click', () => {
    const now = document.body.getAttribute('data-theme') === 'dark' ? 'light' : 'dark';
    document.body.setAttribute('data-theme', now);
    localStorage.setItem('theme', now);
  });
})();
