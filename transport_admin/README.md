transport-system/
│
├── public/                 # Static files
│
├── src/
│   ├── app/                # Pages + API
│   │   ├── (auth)/         # Login / Register pages
│   │   ├── admin/          # Admin Dashboard pages
│   │   └── api/            # Backend API endpoints
│   │
│   ├── components/         # Reusable UI components
│   │   ├── ui/
│   │   ├── layout/
│   │
│   ├── lib/                # Core configurations
│   │
│   ├── services/           # Business logic
│   │
│   └── types/              # TypeScript types
│
├── drizzle/                # Database migrations
│
├── .env.local              # Environment variables
├── drizzle.config.ts       # Drizzle configuration
├── package.json
└── tsconfig.json