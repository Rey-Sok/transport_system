transport_admin/
│
├── prisma/                              # 🗄️ DATABASE
│   ├── schema.prisma                    # កំណត់ table ទាំងអស់ (User, Vehicle, Trip, Booking)
│   ├── migrations/                      # ប្រវត្តិផ្លាស់ប្តូរ DB (commit ទៅ git, កុំកែរបស់ចាស់)
│   └── seed.ts                          # បញ្ចូលទិន្នន័យដំបូង (ឧ. admin user ដំបូង)
│
├── public/                              # 📁 FILE STATIC (ចូលតាម URL ផ្ទាល់)
│   └── images/                          # logo, icon, រូបភាព → /images/logo.png
│
├── src/
│   │
│   ├── app/                             # 🛣️ ROUTING ប៉ុណ្ណោះ (គ្មាន logic, គ្មាន Prisma)
│   │   │
│   │   ├── (auth)/                      # route group: (auth) មិនបង្ហាញក្នុង URL
│   │   │   ├── login/page.tsx           # → /login
│   │   │   └── register/page.tsx        # → /register
│   │   │
│   │   ├── admin/                       # ទំព័រសម្រាប់ admin
│   │   │   ├── layout.tsx               # layout រួម (sidebar + navbar) សម្រាប់ទំព័រ admin ទាំងអស់
│   │   │   ├── home/page.tsx            # → /admin/home (dashboard)
│   │   │   ├── trips/page.tsx           # → /admin/trips (គ្រប់គ្រងដំណើរ)
│   │   │   ├── users/page.tsx           # → /admin/users (គ្រប់គ្រងអ្នកប្រើ)
│   │   │   └── vehicles/page.tsx        # → /admin/vehicles (គ្រប់គ្រងយានយន្ត)
│   │   │
│   │   ├── api/                         # REST API endpoints
│   │   │   ├── auth/                    # → /api/auth/... (login, logout, session)
│   │   │   ├── bookings/route.ts        # → /api/bookings (GET, POST)
│   │   │   ├── users/route.ts           # → /api/users (GET list, POST create)
│   │   │   └── upload/route.ts          # → /api/upload (upload file)
│   │   │
│   │   ├── layout.tsx                   # layout ធំបំផុត (<html>, <body>)
│   │   ├── globals.css                  # CSS សកល (Tailwind)
│   │   └── page.tsx                     # → / (ទំព័រដើម)
│   │
│   ├── features/                        # 🧠 BUSINESS LOGIC (មួយ feature = មួយ module ឯករាជ្យ)
│   │   │
│   │   ├── users/                       # feature: អ្នកប្រើ
│   │   │   ├── components/              # UI ប្រើតែក្នុង feature នេះ
│   │   │   │   ├── create-user-form.tsx # form បង្កើត user ("use client", ហៅ API ដោយ fetch)
│   │   │   │   └── user-table.tsx       # តារាងបង្ហាញ user
│   │   │   ├── repository.ts            # កន្លែងតែមួយដែលប៉ះ Prisma (db.user.findMany ...)
│   │   │   ├── service.ts               # business rules (ពិនិត្យ email ស្ទួន, hash password)
│   │   │   └── types.ts                 # Zod schema + TypeScript types
│   │   │
│   │   ├── booking/                     # feature: ការកក់សំបុត្រ
│   │   │   ├── components/
│   │   │   ├── repository.ts
│   │   │   ├── service.ts
│   │   │   └── types.ts
│   │   │
│   │   ├── trips/                       # feature: ដំណើរ, ពេលវេលា, ផ្លូវ
│   │   │   └── (4 items ដូចគ្នា)
│   │   │
│   │   └── vehicles/                    # feature: យានយន្ត, ស្លាកលេខ
│   │       └── (4 items ដូចគ្នា)
│   │
│   ├── components/                      # 🧩 UI ចែករំលែក (feature ច្រើនប្រើរួមគ្នា)
│   │   ├── ui/                          # component តូចៗ
│   │   │   ├── button.tsx
│   │   │   └── input.tsx
│   │   └── layout/                      # រចនាសម្ព័ន្ធទំព័រ
│   │       ├── sidebar.tsx              # ប្រើក្នុង admin/layout.tsx
│   │       └── navbar.tsx
│   │
│   ├── lib/                             # 🔧 ឧបករណ៍ចែករំលែក (infrastructure)
│   │   ├── auth.ts                      # config + helper authentication
│   │   ├── db.ts                        # Prisma client (singleton)
│   │   ├── storage.ts                   # logic upload file (S3, Cloudinary, local)
│   │   ├── env.ts                       # ពិនិត្យ environment variables
│   │   └── errors.ts                    # class AppError សម្រាប់ error ដូចគ្នាទាំង project
│   │
│   ├── generated/                       # ⚙️ AUTO-GENERATED (កុំកែដោយដៃ, ដាក់ក្នុង .gitignore)
│   │   └── prisma/                      # Prisma client ពី `prisma generate`
│   │
│   └── types/                           # 📝 type សកល (ឧ. ពង្រីក session type)
│
├── .env.local                           # 🔐 secret (DATABASE_URL, key) → មិន commit
├── .env.example                         # គំរូ variable ត្រូវការ → commit សម្រាប់ developer ថ្មី
├── .gitignore                           # ឯកសារដែល git មិនតាមដាន (.env.local, generated/, node_modules/)
├── eslint.config.mjs                    # lint rule (ហាម import repository ពី app/)
├── next.config.ts                       # config Next.js
├── package.json                         # dependencies + scripts
└── tsconfig.json                        # config TypeScript + alias `@/`