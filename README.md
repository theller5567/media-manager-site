# Media Manager Marketing Site

Marketing website for Media Manager App - a modern, AI-powered media management platform.

## Tech Stack

- **Framework**: Next.js 16.1.4
- **Language**: TypeScript
- **Styling**: Tailwind CSS 4
- **Animations**: Framer Motion
- **Deployment**: Vercel

## Getting Started

### Prerequisites

- Node.js 18+ 
- pnpm (recommended) or npm

### Installation

```bash
# Install dependencies
pnpm install

# Run development server
pnpm dev
```

Open [http://localhost:3000](http://localhost:3000) to view the site.

### Build

```bash
# Build for production
pnpm build

# Start production server
pnpm start
```

## Project Structure

```
marketing-site/
├── app/                    # Next.js App Router pages
│   ├── api/               # API routes (contact, demo-request)
│   ├── demo/              # Demo page
│   ├── features/          # Features page
│   ├── pricing/           # Pricing page
│   └── page.tsx           # Homepage
├── components/             # React components
│   ├── layout/            # Layout components (Navbar, Footer)
│   ├── sections/          # Page sections (Hero, Features, etc.)
│   └── ui/                # UI components (Carousel, etc.)
├── public/                # Static assets
└── lib/                   # Utility functions
```

## Environment Variables

Create a `.env.local` file for local development:

```env
NEXT_PUBLIC_APP_URL=http://localhost:3000
NEXT_PUBLIC_GOOGLE_ANALYTICS_ID=G-XXXXXXXXXX  # Optional
SENDGRID_API_KEY=SG.xxxxxxxxxxxxx              # Optional (for forms)
```

For production, set these in Vercel Dashboard → Settings → Environment Variables.

## Deployment

This site is deployed on Vercel. See [VERCEL_DEPLOYMENT.md](./VERCEL_DEPLOYMENT.md) for detailed deployment instructions.

### Quick Deploy

1. Push code to GitHub
2. Import repository in Vercel Dashboard
3. Configure Root Directory: `/` (root)
4. Set environment variables
5. Deploy

## Features

- ✅ Responsive design (mobile-first)
- ✅ SEO optimized (metadata, structured data)
- ✅ Contact and demo request forms
- ✅ Google Analytics integration (optional)
- ✅ Fast page loads (Next.js optimizations)
- ✅ Modern UI with animations

## Pages

- **Homepage** (`/`) - Main landing page with hero, features, pricing
- **Features** (`/features`) - Detailed feature showcase
- **Pricing** (`/pricing`) - Pricing plans and comparison
- **Demo** (`/demo`) - Demo request page

## API Routes

- **POST `/api/contact`** - Contact form submission
- **POST `/api/demo-request`** - Demo request form submission

Currently, forms log to console. See API route files for SendGrid integration TODO.

## Development

### Code Style

- TypeScript strict mode enabled
- ESLint configured with Next.js rules
- Tailwind CSS for styling
- Component-based architecture

### Adding New Pages

1. Create new file in `app/` directory (e.g., `app/about/page.tsx`)
2. Export default React component
3. Add navigation link in `components/layout/Navbar.tsx`

### Adding New Components

1. Create component file in appropriate `components/` subdirectory
2. Use TypeScript with proper types
3. Follow existing component patterns

## License

Private - All rights reserved
