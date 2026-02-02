"use client";

import { useState } from "react";
import { Send } from "lucide-react";
import { CTA } from "@/components/sections/CTA";


export default function DemoPage() {
  const [formData, setFormData] = useState({
    name: "",
    email: "",
    company: "",
    message: "",
  });
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [submitStatus, setSubmitStatus] = useState<"idle" | "success" | "error">("idle");

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setIsSubmitting(true);
    setSubmitStatus("idle");

    try {
      const response = await fetch("/api/demo-request", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(formData),
      });

      if (response.ok) {
        setSubmitStatus("success");
        setFormData({ name: "", email: "", company: "", message: "" });
      } else {
        setSubmitStatus("error");
      }
    } catch (error) {
      setSubmitStatus("error");
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <main className="min-h-screen pt-16">
      {/* Hero Section */}
      <section className="pt-20 pb-10 px-4 bg-linear-to-b from-slate-900 via-slate-800 to-slate-900">
        <div className="max-w-4xl mx-auto text-center">
          <h1 className="text-4xl md:text-6xl font-bold text-white mb-6">
            See <span className="bg-linear-to-r from-cyan-400 to-blue-500 bg-clip-text text-transparent">Synapse</span> in Action
          </h1>
          <p className="text-xl text-slate-300 mb-12 max-w-2xl mx-auto">
            Watch a quick demo or schedule a personalized walkthrough with our team.
          </p>
        </div>
      </section>

      {/* Demo Video Section - video served from Vercel Blob */}
      <section className="pb-20 px-4 bg-slate-900" aria-labelledby="demo-video-heading">
        <div className="max-w-4xl mx-auto">
          <h2 id="demo-video-heading" className="sr-only">
            Synapse demo video
          </h2>
          <div className="aspect-video bg-slate-800 rounded-lg border border-slate-700 overflow-hidden mb-8">
            {process.env.NEXT_PUBLIC_DEMO_VIDEO_URL ? (
              <video
                className="w-full h-full object-contain"
                src={process.env.NEXT_PUBLIC_DEMO_VIDEO_URL}
                controls
                playsInline
                preload="metadata"
                aria-label="Synapse product demo video"
                title="Synapse demo video"
              >
                <p className="p-4 text-slate-400">
                  Your browser does not support the video tag.{" "}
                  <a href={process.env.NEXT_PUBLIC_DEMO_VIDEO_URL} className="text-cyan-400 underline" target="_blank" rel="noopener noreferrer">
                    Download the demo video
                  </a>
                  .
                </p>
              </video>
            ) : (
              <div className="w-full h-full flex items-center justify-center text-slate-400 p-8 text-center">
                <p>Demo video URL not configured. Set NEXT_PUBLIC_DEMO_VIDEO_URL to your Vercel Blob URL.</p>
              </div>
            )}
          </div>
        </div>
      </section>

      {/* Request Demo Form */}
      <section className="py-20 px-4 bg-slate-800">
        <div className="max-w-2xl mx-auto">
          <div className="text-center mb-12">
            <h2 className="text-3xl md:text-4xl font-bold text-white mb-4">
              Request a Personalized Demo
            </h2>
            <p className="text-xl text-slate-400">
              Let us show you how Synapse can transform your media workflow.
            </p>
          </div>

          <form onSubmit={handleSubmit} className="bg-slate-900 p-8 rounded-lg border border-slate-700">
            <div className="space-y-6">
              <div>
                <label htmlFor="name" className="block text-sm font-medium text-white mb-2">
                  Name
                </label>
                <input
                  type="text"
                  id="name"
                  required
                  value={formData.name}
                  onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                  className="w-full px-4 py-3 bg-slate-800 border border-slate-700 rounded-lg text-white focus:outline-none focus:ring-2 focus:ring-cyan-500"
                />
              </div>

              <div>
                <label htmlFor="email" className="block text-sm font-medium text-white mb-2">
                  Email
                </label>
                <input
                  type="email"
                  id="email"
                  required
                  value={formData.email}
                  onChange={(e) => setFormData({ ...formData, email: e.target.value })}
                  className="w-full px-4 py-3 bg-slate-800 border border-slate-700 rounded-lg text-white focus:outline-none focus:ring-2 focus:ring-cyan-500"
                />
              </div>

              <div>
                <label htmlFor="company" className="block text-sm font-medium text-white mb-2">
                  Company
                </label>
                <input
                  type="text"
                  id="company"
                  value={formData.company}
                  onChange={(e) => setFormData({ ...formData, company: e.target.value })}
                  className="w-full px-4 py-3 bg-slate-800 border border-slate-700 rounded-lg text-white focus:outline-none focus:ring-2 focus:ring-cyan-500"
                />
              </div>

              <div>
                <label htmlFor="message" className="block text-sm font-medium text-white mb-2">
                  Message (Optional)
                </label>
                <textarea
                  id="message"
                  rows={4}
                  value={formData.message}
                  onChange={(e) => setFormData({ ...formData, message: e.target.value })}
                  className="w-full px-4 py-3 bg-slate-800 border border-slate-700 rounded-lg text-white focus:outline-none focus:ring-2 focus:ring-cyan-500"
                />
              </div>

              {submitStatus === "success" && (
                <div className="bg-green-500/10 border border-green-500 text-green-400 px-4 py-3 rounded-lg">
                  Thank you! We'll be in touch soon.
                </div>
              )}

              {submitStatus === "error" && (
                <div className="bg-red-500/10 border border-red-500 text-red-400 px-4 py-3 rounded-lg">
                  Something went wrong. Please try again.
                </div>
              )}

              <button
                type="submit"
                disabled={isSubmitting}
                className="w-full bg-cyan-500 hover:bg-cyan-600 text-white font-semibold px-8 py-4 rounded-lg transition-colors flex items-center justify-center gap-2 disabled:opacity-50"
              >
                {isSubmitting ? (
                  "Sending..."
                ) : (
                  <>
                    <Send className="h-5 w-5" />
                    Request Demo
                  </>
                )}
              </button>
            </div>
          </form>
        </div>
      </section>

      <CTA />
    </main>
  );
}
