<script>
(async () => {
  const mount = document.getElementById('ax-footer');
  if (!mount) return;

  const FOOTER_URL = '/sections/footer-axonexus.html'; // único origen

  try {
    const res = await fetch(FOOTER_URL, { cache: 'no-store' });
    if (!res.ok) throw new Error('HTTP ' + res.status);
    const html = await res.text();
    mount.innerHTML = html;
  } catch (err) {
    console.error('Footer Axonexus: no se pudo cargar.', err);
    mount.innerHTML =
      '<div style="padding:24px;text-align:center;color:#aaa;border-top:1px solid #222;">' +
      'Footer no disponible.</div>';
  }
})();
</script>

