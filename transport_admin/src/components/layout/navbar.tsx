import Link from "next/link";

export function Navbar() {
  return (
    <header className="sticky top-0 z-30 border-b border-slate-200 bg-white">
      <div className="flex h-16 items-center justify-between px-4 sm:px-6">
        <Link
          href="/admin/dashboard"
          className="flex items-center gap-3 rounded-md focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-blue-600"
        >
          <span
            aria-hidden="true"
            className="flex size-9 items-center justify-center rounded-lg bg-blue-700 text-sm font-bold text-white"
          >
            TS
          </span>
          <span className="text-base font-semibold tracking-tight text-slate-900">
            Transport Admin
          </span>
        </Link>

        <div className="flex items-center gap-3">
          <span className="hidden text-sm text-slate-600 sm:inline">
            Administrator
          </span>
          <span
            aria-label="Administrator profile"
            className="flex size-9 items-center justify-center rounded-full bg-slate-100 text-sm font-semibold text-slate-700"
          >
            A
          </span>
        </div>
      </div>
    </header>
  );
}
