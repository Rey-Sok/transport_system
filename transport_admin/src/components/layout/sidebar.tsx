import Link from "next/link";

const navigation = [
  { label: "Dashboard", href: "/admin/dashboard" },
  { label: "Vehicles", href: "/admin/vehicles" },
  { label: "Routes", href: "/admin/routes" },
  { label: "Trips", href: "/admin/trips" },
  { label: "Bookings", href: "/admin/bookings" },
  { label: "Users", href: "/admin/users" },
];

export function Sidebar() {
  return (
    <aside className="w-full shrink-0 border-b border-slate-200 bg-white md:w-60 md:border-r md:border-b-0">
      <nav
        aria-label="Admin navigation"
        className="flex gap-1 overflow-x-auto p-3 md:flex-col md:gap-2 md:p-4"
      >
        {navigation.map((item) => (
          <Link
            key={item.href}
            href={item.href}
            className="whitespace-nowrap rounded-lg px-3 py-2 text-sm font-medium text-slate-600 transition-colors hover:bg-slate-100 hover:text-slate-950 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-blue-600"
          >
            {item.label}
          </Link>
        ))}
      </nav>
    </aside>
  );
}
