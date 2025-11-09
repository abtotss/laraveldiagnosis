(
  echo "=== TIMESTAMP ==="; date; echo
  echo "=== PROJECT PATH ==="; pwd; echo

  echo "=== GIT BRANCH & STATUS ==="
  git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "no-git"
  git status --porcelain 2>/dev/null || echo "git status unavailable"
  echo

  echo "=== LAST 40 COMMITS ==="
  git log --oneline -n 40 2>/dev/null || echo "git log unavailable"
  echo

  echo "=== BRANCHES ==="
  git branch -a 2>/dev/null || echo "git branch unavailable"
  echo

  echo "=== INSTALLED PHP PACKAGES (composer show top) ==="
  composer show --no-interaction 2>/dev/null | sed -n '1,120p' || echo "composer show unavailable"
  echo

  echo "=== PACKAGE.JSON (dependencies) ==="
  if [ -f package.json ]; then cat package.json | sed -n '1,200p'; else echo "no package.json"; fi
  echo

  echo "=== PHP / NODE / NPM VERSIONS ==="
  php -v 2>/dev/null || echo "php not found"
  node -v 2>/dev/null || echo "node not found"
  npm -v 2>/dev/null || echo "npm not found"
  echo

  echo "=== ARTISAN MIGRATE STATUS ==="
  php artisan migrate:status 2>/dev/null || echo "migrate:status unavailable"
  echo

  echo "=== ROUTE LIST (compact) ==="
  php artisan route:list --compact 2>/dev/null | sed -n '1,200p' || echo "route:list unavailable"
  echo

  echo "=== LIST OF IMPORTANT FILES (first 200 lines each if present) ==="
  for f in composer.json artisan routes/web.php app/Http/Kernel.php app/Models/User.php resources/views/layouts/app.blade.php; do
    echo "---- $f ----"
    if [ -f "$f" ]; then sed -n '1,200p' "$f"; else echo "MISSING: $f"; fi
    echo
  done

  echo "=== DATABASE MIGRATIONS (list) ==="
  ls -1 database/migrations 2>/dev/null || echo "migrations folder missing"
  echo

  echo "=== LAST 200 LINES OF LARAVEL LOG ==="
  if [ -f storage/logs/laravel.log ]; then tail -n 200 storage/logs/laravel.log; else echo "no laravel.log"; fi
  echo

  echo "=== END OF DIAGNOSTICS ==="
) > diagnostics.txt && echo "diagnostics.txt created at $(pwd)/diagnostics.txt"
