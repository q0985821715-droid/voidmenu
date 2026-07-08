#!/data/data/com.termux/files/usr/bin/bash
set -e
ROOT="$HOME/voidmenu"
mkdir -p "$ROOT"/{app/dashboard/products,components,prisma,public}
cd "$ROOT"

cat > package.json << 'EOF'
{"name":"voidmenu","version":"1.0.0","private":true,"scripts":{"dev":"next dev -H 0.0.0.0","build":"next build","start":"next start -H 0.0.0.0"},"dependencies":{"next":"15.0.0","react":"^18.3.1","react-dom":"^18.3.1","@prisma/client":"^5.15.0","tailwindcss":"^3.4.0","qrcode":"^1.5.3"},"devDependencies":{"prisma":"^5.15.0","typescript":"^5.5.0","@types/react":"^18.3.0","@types/node":"^20.0.0","@types/qrcode":"^1.5.5","postcss":"^8.4.0","autoprefixer":"^10.4.0"}}
EOF

printf 'node_modules/\n.next/\n.env\n.env.local\n' > .gitignore
echo '/// <reference types="next" />' > next-env.d.ts
echo 'const nextConfig={};export default nextConfig;' > next.config.mjs
echo 'export default {plugins:{tailwindcss:{},autoprefixer:{}}};' > postcss.config.mjs

cat > tailwind.config.ts << 'EOF'
import type { Config } from "tailwindcss";
export default { content: ["./app/**/*.{js,ts,jsx,tsx}","./components/**/*.{js,ts,jsx,tsx}"], theme:{extend:{}}, plugins:[] } satisfies Config;
EOF

cat > tsconfig.json << 'EOF'
{"compilerOptions":{"target":"ES2017","lib":["dom","dom.iterable","esnext"],"allowJs":true,"skipLibCheck":true,"strict":true,"noEmit":true,"esModuleInterop":true,"module":"esnext","moduleResolution":"bundler","resolveJsonModule":true,"isolatedModules":true,"jsx":"preserve","incremental":true,"plugins":[{"name":"next"}],"paths":{"@/*":["./*"]}},"include":["next-env.d.ts","**/*.ts","**/*.tsx"],"exclude":["node_modules"]}
EOF

cat > app/globals.css << 'EOF'
@tailwind base;@tailwind components;@tailwind utilities;
body{font-family:"Noto Sans Khmer",system-ui,sans-serif;}
EOF

cat > prisma/schema.prisma << 'EOF'
generator client { provider = "prisma-client-js" }
datasource db { provider = "postgresql"; url = env("DATABASE_URL") }
model Shop { id String @id @default(cuid()) name String ownerId String slug String @unique logo String? createdAt DateTime @default(now()) products Product[] }
model Product { id String @id @default(cuid()) shopId String name String price Float description String? image String? category String shop Shop @relation(fields: [shopId], references: [id]) }
EOF

echo "Part A OK -> $ROOT"
