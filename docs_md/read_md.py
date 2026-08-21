#!/usr/bin/env python3
"""
Markdown Documentation Web Server
Serves all .md files in the directory via an intuitive, responsive web UI.
Features:
- File tree navigation with instant search & filter
- GitHub-styled Markdown rendering with dark/light mode toggle
- Syntax highlighting for code blocks with copy-to-clipboard
- Mermaid.js diagram rendering
- Table of Contents auto-generation
- Full-text search across all markdown files
- Automatic relative link handling
"""

import os
import sys
import json
import urllib.parse
import http.server
import socketserver
import argparse
import webbrowser
from pathlib import Path

# Base directory defaults to the directory where server.py is located
BASE_DIR = os.path.dirname(os.path.abspath(__file__))

# Ignore hidden folders and common non-doc build dirs
EXCLUDE_DIRS = {'.git', '.agents', '.gemini', 'node_modules', '__pycache__', '.idea', '.vscode', 'vendor'}

def find_md_files(base_dir):
    """Recursively discover all .md files relative to base_dir."""
    md_files = []
    for root, dirs, files in os.walk(base_dir):
        # Filter out excluded directories in-place
        dirs[:] = [d for d in dirs if d not in EXCLUDE_DIRS and not d.startswith('.')]
        for f in files:
            if f.endswith('.md'):
                full_path = os.path.join(root, f)
                rel_path = os.path.relpath(full_path, base_dir)
                
                # Try reading first line for title
                title = f
                try:
                    with open(full_path, 'r', encoding='utf-8', errors='ignore') as fp:
                        for line in fp:
                            line = line.strip()
                            if line.startswith('# '):
                                title = line[2:].strip()
                                break
                            elif line and not line.startswith('#'):
                                break
                except Exception:
                    pass

                mtime = os.path.getmtime(full_path)
                size = os.path.getsize(full_path)
                
                md_files.append({
                    "path": rel_path,
                    "name": f,
                    "title": title,
                    "mtime": mtime,
                    "size": size,
                    "dir": os.path.dirname(rel_path)
                })
    
    # Sort files by path
    md_files.sort(key=lambda x: x["path"].lower())
    return md_files

def full_text_search(base_dir, query):
    """Search for query string across all .md files."""
    if not query or len(query.strip()) < 2:
        return []
    
    query_lower = query.strip().lower()
    results = []
    files = find_md_files(base_dir)
    
    for f in files:
        full_path = os.path.join(base_dir, f["path"])
        try:
            with open(full_path, 'r', encoding='utf-8', errors='ignore') as fp:
                content = fp.read()
                if query_lower in content.lower():
                    # Extract snippets
                    lines = content.splitlines()
                    snippets = []
                    for idx, line in enumerate(lines):
                        if query_lower in line.lower():
                            snippet_text = line.strip()
                            if len(snippet_text) > 120:
                                pos = snippet_text.lower().find(query_lower)
                                start = max(0, pos - 40)
                                end = min(len(snippet_text), pos + 80)
                                snippet_text = ("..." if start > 0 else "") + snippet_text[start:end] + ("..." if end < len(snippet_text) else "")
                            snippets.append({"line": idx + 1, "text": snippet_text})
                            if len(snippets) >= 4:
                                break
                    results.append({
                        "file": f,
                        "matches_count": content.lower().count(query_lower),
                        "snippets": snippets
                    })
        except Exception:
            continue
            
    results.sort(key=lambda x: x["matches_count"], reverse=True)
    return results

HTML_TEMPLATE = r"""<!DOCTYPE html>
<html lang="en" class="h-full">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Markdown Documentation Portal</title>
    
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            darkMode: 'class',
            theme: {
                extend: {
                    colors: {
                        brand: {
                            50: '#f0fdf4',
                            100: '#dcfce7',
                            500: '#22c55e',
                            600: '#16a34a',
                            700: '#15803d',
                            900: '#14532d',
                        }
                    }
                }
            }
        }
    </script>
    
    <!-- GitHub Markdown CSS -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/github-markdown-css/5.5.1/github-markdown.min.css">
    
    <!-- Highlight.js for Code Highlighting -->
    <link rel="stylesheet" id="hljs-theme" href="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/styles/github.min.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/highlight.min.js"></script>
    
    <!-- Marked.js for Markdown Parsing -->
    <script src="https://cdn.jsdelivr.net/npm/marked/marked.min.js"></script>

    <!-- Mermaid.js for Diagrams -->
    <script src="https://cdn.jsdelivr.net/npm/mermaid/dist/mermaid.min.js"></script>

    <!-- Lucide Icons -->
    <script src="https://unpkg.com/lucide@latest"></script>

    <style>
        /* Custom scrollbars */
        ::-webkit-scrollbar { width: 6px; height: 6px; }
        ::-webkit-scrollbar-track { background: transparent; }
        ::-webkit-scrollbar-thumb { background: rgba(156, 163, 175, 0.4); border-radius: 4px; }
        ::-webkit-scrollbar-thumb:hover { background: rgba(156, 163, 175, 0.7); }

        .markdown-body {
            box-sizing: border-box;
            min-width: 200px;
            max-width: 980px;
            margin: 0 auto;
            padding: 2rem;
            background-color: transparent !important;
        }

        .dark .markdown-body {
            color-scheme: dark;
            color: #c9d1d9;
        }
        
        .dark .markdown-body pre code {
            color: #e6edf3;
        }

        .dark .markdown-body table tr {
            background-color: #0d1117;
            border-top-color: #21262d;
        }

        .dark .markdown-body table tr:nth-child(2n) {
            background-color: #161b22;
        }

        .dark .markdown-body table th, .dark .markdown-body table td {
            border-color: #30363d;
        }

        .dark .markdown-body blockquote {
            color: #8b949e;
            border-left-color: #30363d;
        }

        .dark .markdown-body h1, .dark .markdown-body h2 {
            border-bottom-color: #21262d;
        }
        
        .code-block-wrapper {
            position: relative;
        }
        .copy-code-btn {
            position: absolute;
            top: 0.5rem;
            right: 0.5rem;
            padding: 0.25rem 0.5rem;
            font-size: 0.75rem;
            border-radius: 0.375rem;
            background: rgba(255,255,255,0.1);
            backdrop-filter: blur(4px);
            color: #ccc;
            opacity: 0;
            transition: opacity 0.2s, background 0.2s;
            cursor: pointer;
        }
        .code-block-wrapper:hover .copy-code-btn {
            opacity: 1;
        }
        .copy-code-btn:hover {
            background: rgba(255,255,255,0.25);
            color: #fff;
        }

        /* Active TOC link */
        .toc-link.active {
            font-weight: 600;
            color: #22c55e;
            border-left: 2px solid #22c55e;
            padding-left: 0.5rem;
        }
    </style>
</head>
<body class="h-full bg-slate-50 dark:bg-slate-900 text-slate-800 dark:text-slate-100 flex flex-col font-sans transition-colors duration-200">

    <!-- Top Navigation Bar -->
    <header class="h-14 border-b border-slate-200 dark:border-slate-800 bg-white/80 dark:bg-slate-900/80 backdrop-blur sticky top-0 z-30 flex items-center justify-between px-4">
        <div class="flex items-center space-x-3">
            <button id="toggle-sidebar-btn" class="p-1.5 rounded-lg text-slate-500 hover:bg-slate-100 dark:hover:bg-slate-800 transition lg:hidden">
                <i data-lucide="menu" class="w-5 h-5"></i>
            </button>
            <div class="flex items-center space-x-2">
                <div class="bg-brand-600 text-white p-1.5 rounded-lg shadow-sm">
                    <i data-lucide="book-open" class="w-5 h-5"></i>
                </div>
                <span class="font-bold text-lg tracking-tight bg-gradient-to-r from-slate-900 to-slate-700 dark:from-white dark:to-slate-300 bg-clip-text text-transparent">
                    Markdown Docs
                </span>
                <span id="doc-count-badge" class="text-xs bg-slate-100 dark:bg-slate-800 text-slate-500 dark:text-slate-400 px-2 py-0.5 rounded-full font-medium">
                    Loading...
                </span>
            </div>
        </div>

        <div class="flex items-center space-x-2">
            <!-- Fulltext search button/input modal toggle -->
            <div class="relative hidden sm:block w-64 md:w-80">
                <i data-lucide="search" class="w-4 h-4 absolute left-3 top-1/2 -translate-y-1/2 text-slate-400"></i>
                <input id="quick-search-input" type="text" placeholder="Search files or contents... (Press /)" 
                       class="w-full pl-9 pr-4 py-1.5 text-sm bg-slate-100 dark:bg-slate-800 border border-transparent dark:border-slate-700/60 rounded-lg focus:outline-none focus:ring-2 focus:ring-brand-500/50 transition">
            </div>

            <!-- Dark mode toggle -->
            <button id="theme-toggle" class="p-2 text-slate-500 dark:text-slate-400 hover:bg-slate-100 dark:hover:bg-slate-800 rounded-lg transition" title="Toggle Theme">
                <i data-lucide="moon" class="w-5 h-5 dark:hidden"></i>
                <i data-lucide="sun" class="w-5 h-5 hidden dark:block"></i>
            </button>
        </div>
    </header>

    <div class="flex-1 flex overflow-hidden">
        <!-- Sidebar -->
        <aside id="sidebar" class="w-80 border-r border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 flex flex-col transition-all duration-300 z-20 absolute lg:relative inset-y-0 left-0 -translate-x-full lg:translate-x-0 shadow-lg lg:shadow-none">
            <!-- Sidebar Header / Filter -->
            <div class="p-3 border-b border-slate-200 dark:border-slate-800 space-y-2">
                <div class="relative">
                    <i data-lucide="filter" class="w-4 h-4 absolute left-3 top-1/2 -translate-y-1/2 text-slate-400"></i>
                    <input id="file-filter-input" type="text" placeholder="Filter file tree..." 
                           class="w-full pl-9 pr-3 py-1.5 text-sm bg-slate-50 dark:bg-slate-800/80 border border-slate-200 dark:border-slate-700 rounded-md focus:outline-none focus:ring-2 focus:ring-brand-500/50">
                </div>
                <div class="flex items-center justify-between text-xs text-slate-500 px-1">
                    <button id="collapse-all-btn" class="hover:text-brand-600 transition flex items-center space-x-1">
                        <i data-lucide="fold-vertical" class="w-3.5 h-3.5"></i>
                        <span>Collapse all</span>
                    </button>
                    <button id="expand-all-btn" class="hover:text-brand-600 transition flex items-center space-x-1">
                        <i data-lucide="unfold-vertical" class="w-3.5 h-3.5"></i>
                        <span>Expand all</span>
                    </button>
                </div>
            </div>

            <!-- File List Tree -->
            <div id="file-tree-container" class="flex-1 overflow-y-auto p-2 space-y-1 text-sm">
                <div class="p-4 text-center text-slate-400 animate-pulse">Scanning markdown files...</div>
            </div>

            <!-- Sidebar Footer -->
            <div class="p-3 border-t border-slate-200 dark:border-slate-800 text-xs text-slate-400 flex items-center justify-between">
                <span>Local Docs Server</span>
                <span class="font-mono bg-slate-100 dark:bg-slate-800 px-1.5 py-0.5 rounded">Python 3</span>
            </div>
        </aside>

        <!-- Main Content Area -->
        <main class="flex-1 flex overflow-hidden relative">
            <div class="flex-1 overflow-y-auto flex flex-col" id="main-scroll-container">
                
                <!-- Content Top Bar / Breadcrumb -->
                <div id="content-header" class="hidden px-6 py-3 border-b border-slate-200 dark:border-slate-800 bg-slate-50/50 dark:bg-slate-900/50 flex flex-wrap items-center justify-between gap-3 sticky top-0 backdrop-blur z-10">
                    <div class="flex items-center space-x-2 text-sm text-slate-600 dark:text-slate-300 overflow-x-auto py-1">
                        <i data-lucide="file-text" class="w-4 h-4 text-brand-600 flex-shrink-0"></i>
                        <span id="breadcrumb-path" class="font-mono text-xs font-semibold"></span>
                    </div>

                    <div class="flex items-center space-x-2">
                        <button id="raw-toggle-btn" class="px-2.5 py-1 text-xs font-medium bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-md hover:bg-slate-50 dark:hover:bg-slate-700 transition flex items-center space-x-1">
                            <i data-lucide="code" class="w-3.5 h-3.5"></i>
                            <span id="raw-toggle-text">View Raw</span>
                        </button>

                        <button id="copy-path-btn" class="px-2.5 py-1 text-xs font-medium bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-md hover:bg-slate-50 dark:hover:bg-slate-700 transition flex items-center space-x-1">
                            <i data-lucide="copy" class="w-3.5 h-3.5"></i>
                            <span>Copy Path</span>
                        </button>
                    </div>
                </div>

                <!-- Markdown Content Render View -->
                <div id="content-body" class="flex-1 p-4 lg:p-8 flex justify-center">
                    <div id="welcome-screen" class="max-w-xl mx-auto my-auto text-center space-y-6 p-6">
                        <div class="w-16 h-16 bg-brand-100 dark:bg-brand-900/30 text-brand-600 rounded-2xl flex items-center justify-center mx-auto shadow-inner">
                            <i data-lucide="file-spreadsheet" class="w-8 h-8"></i>
                        </div>
                        <div class="space-y-2">
                            <h2 class="text-2xl font-bold tracking-tight">Selamat Datang di Portal Dokumentasi</h2>
                            <p class="text-slate-500 dark:text-slate-400 text-sm leading-relaxed">
                                Pilih salah satu berkas markdown di panel sebelah kiri untuk mulai membaca.
                            </p>
                        </div>
                        <div id="quick-stats" class="grid grid-cols-2 gap-3 pt-4 text-left">
                            <!-- Stats injected via JS -->
                        </div>
                    </div>

                    <div id="markdown-container" class="hidden w-full max-w-4xl">
                        <article id="rendered-markdown" class="markdown-body"></article>
                        <textarea id="raw-markdown" class="hidden w-full h-[calc(100vh-12rem)] font-mono text-sm p-4 bg-slate-900 text-slate-100 rounded-lg border border-slate-800 focus:outline-none resize-none" readonly></textarea>
                    </div>
                </div>
            </div>

            <!-- Table of Contents Sidebar (Right side) -->
            <aside id="toc-sidebar" class="hidden xl:block w-64 border-l border-slate-200 dark:border-slate-800 bg-white/50 dark:bg-slate-900/50 overflow-y-auto p-4 space-y-3">
                <div class="flex items-center space-x-2 text-xs font-bold uppercase tracking-wider text-slate-400">
                    <i data-lucide="list" class="w-4 h-4"></i>
                    <span>Daftar Isi</span>
                </div>
                <nav id="toc-list" class="space-y-1 text-xs text-slate-600 dark:text-slate-400">
                    <span class="italic text-slate-400">Tidak ada H1/H2 ditemukan</span>
                </nav>
            </aside>
        </main>
    </div>

    <!-- Search Modal -->
    <div id="search-modal" class="fixed inset-0 z-50 bg-slate-900/50 backdrop-blur-sm hidden flex items-start justify-center pt-16 px-4">
        <div class="bg-white dark:bg-slate-900 w-full max-w-2xl rounded-xl shadow-2xl border border-slate-200 dark:border-slate-800 overflow-hidden flex flex-col max-h-[80vh]">
            <div class="p-4 border-b border-slate-200 dark:border-slate-800 flex items-center space-x-3">
                <i data-lucide="search" class="w-5 h-5 text-slate-400"></i>
                <input id="modal-search-input" type="text" placeholder="Ketik kata kunci untuk mencari di seluruh dokumen..." 
                       class="flex-1 bg-transparent text-base focus:outline-none dark:text-white">
                <button id="close-search-modal" class="p-1 rounded-md hover:bg-slate-100 dark:hover:bg-slate-800 text-slate-400">
                    <i data-lucide="x" class="w-5 h-5"></i>
                </button>
            </div>

            <div id="search-results-container" class="flex-1 overflow-y-auto p-4 space-y-4">
                <div class="text-center text-slate-400 text-sm py-8">Ketik minimal 2 karakter untuk mencari...</div>
            </div>
        </div>
    </div>

    <!-- Client-Side JavaScript Logic -->
    <script>
        // State Management
        let allFiles = [];
        let currentFile = null;
        let isRawView = false;

        // Initialize Mermaid
        mermaid.initialize({
            startOnLoad: false,
            theme: document.documentElement.classList.contains('dark') ? 'dark' : 'default',
            securityLevel: 'loose'
        });

        // Initialize Lucide Icons
        lucide.createIcons();

        // Theme Toggle Handler
        const themeToggleBtn = document.getElementById('theme-toggle');
        
        function applyTheme(isDark) {
            if (isDark) {
                document.documentElement.classList.add('dark');
                document.getElementById('hljs-theme').href = "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/styles/github-dark.min.css";
                localStorage.setItem('theme', 'dark');
            } else {
                document.documentElement.classList.remove('dark');
                document.getElementById('hljs-theme').href = "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/styles/github.min.css";
                localStorage.setItem('theme', 'light');
            }
        }

        const savedTheme = localStorage.getItem('theme');
        if (savedTheme === 'dark' || (!savedTheme && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
            applyTheme(true);
        } else {
            applyTheme(false);
        }

        themeToggleBtn.addEventListener('click', () => {
            const isDark = !document.documentElement.classList.contains('dark');
            applyTheme(isDark);
            if (currentFile) renderMarkdownContent(document.getElementById('raw-markdown').value);
        });

        // Configure Marked Parser
        const renderer = new marked.Renderer();
        
        // Custom link renderer to make relative .md links navigate inside app
        renderer.link = function(href, title, text) {
            if (typeof href === 'object') {
                title = href.title;
                text = href.text;
                href = href.href;
            }
            if (href && !href.startsWith('http://') && !href.startsWith('https://') && !href.startsWith('#')) {
                // If it's a relative link to an md file
                let targetPath = href;
                if (currentFile && currentFile.dir) {
                    targetPath = currentFile.dir + '/' + href;
                }
                targetPath = targetPath.replace(/\/\/+/g, '/');
                return `<a href="#" onclick="loadDoc('${targetPath}'); return false;" class="text-brand-600 dark:text-brand-500 underline font-medium" title="${title || ''}">${text}</a>`;
            }
            return `<a href="${href}" target="_blank" rel="noopener noreferrer" class="text-brand-600 dark:text-brand-500 underline font-medium" title="${title || ''}">${text}</a>`;
        };

        // Custom code block renderer for copy button & mermaid diagrams
        renderer.code = function(code, language) {
            if (typeof code === 'object') {
                language = code.lang;
                code = code.text;
            }
            if (language === 'mermaid') {
                return `<div class="mermaid flex justify-center my-6 p-4 bg-slate-100 dark:bg-slate-800/60 rounded-lg overflow-x-auto">${code}</div>`;
            }

            const validLang = hljs.getLanguage(language) ? language : 'plaintext';
            const highlighted = hljs.highlight(code, { language: validLang }).value;
            
            return `<div class="code-block-wrapper my-4">
                <button class="copy-code-btn" onclick="copyCode(this)">Copy</button>
                <pre><code class="hljs language-${validLang}">${highlighted}</code></pre>
            </div>`;
        };

        marked.setOptions({
            renderer: renderer,
            gfm: true,
            breaks: true
        });

        function copyCode(btn) {
            const code = btn.nextElementSibling.innerText;
            navigator.clipboard.writeText(code).then(() => {
                btn.innerText = 'Copied!';
                setTimeout(() => { btn.innerText = 'Copy'; }, 2000);
            });
        }

        // Fetch & Build File Tree
        async function fetchFiles() {
            try {
                const res = await fetch('/api/files');
                allFiles = await res.json();
                
                document.getElementById('doc-count-badge').innerText = `${allFiles.length} docs`;
                renderFileTree(allFiles);
                renderQuickStats(allFiles);

                // Auto load file if specified in hash URL (e.g. #path/to/file.md)
                const hash = window.location.hash.substring(1);
                if (hash) {
                    loadDoc(decodeURIComponent(hash));
                }
            } catch (err) {
                console.error('Failed to fetch file tree:', err);
            }
        }

        function renderQuickStats(files) {
            const dirs = new Set(files.map(f => f.dir || 'Root'));
            const statsContainer = document.getElementById('quick-stats');
            statsContainer.innerHTML = `
                <div class="p-3 bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-700/60 rounded-xl">
                    <div class="text-xs text-slate-400 uppercase font-semibold">Total Berkas</div>
                    <div class="text-xl font-bold text-brand-600 dark:text-brand-500 mt-0.5">${files.length} .md files</div>
                </div>
                <div class="p-3 bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-700/60 rounded-xl">
                    <div class="text-xs text-slate-400 uppercase font-semibold">Direktori</div>
                    <div class="text-xl font-bold text-slate-700 dark:text-slate-200 mt-0.5">${dirs.size} folder</div>
                </div>
            `;
        }

        function renderFileTree(files) {
            const container = document.getElementById('file-tree-container');
            container.innerHTML = '';

            if (!files || files.length === 0) {
                container.innerHTML = '<div class="p-4 text-center text-slate-400">Tidak ada berkas markdown ditemukan</div>';
                return;
            }

            // Build directory tree data structure cleanly
            const rootNode = { files: [], subdirs: {} };
            files.forEach(file => {
                const parts = file.path.split('/');
                let current = rootNode;
                for (let i = 0; i < parts.length - 1; i++) {
                    const dir = parts[i];
                    if (!current.subdirs[dir]) {
                        current.subdirs[dir] = { files: [], subdirs: {} };
                    }
                    current = current.subdirs[dir];
                }
                current.files.push(file);
            });

            function countFiles(node) {
                let count = node.files.length;
                Object.values(node.subdirs).forEach(sub => {
                    count += countFiles(sub);
                });
                return count;
            }

            function buildTreeDOM(node) {
                const ul = document.createElement('ul');
                ul.className = 'pl-2 space-y-0.5 border-l border-slate-200 dark:border-slate-800 ml-2';

                // 1. Subdirectories first
                const dirNames = Object.keys(node.subdirs).sort();
                dirNames.forEach(dirName => {
                    const subNode = node.subdirs[dirName];
                    const li = document.createElement('li');
                    
                    const dirHeader = document.createElement('div');
                    dirHeader.className = 'flex items-center justify-between px-2 py-1.5 rounded-md hover:bg-slate-100 dark:hover:bg-slate-800 cursor-pointer group text-slate-700 dark:text-slate-300 font-medium transition';
                    
                    const totalFilesInDir = countFiles(subNode);
                    dirHeader.innerHTML = `
                        <div class="flex items-center space-x-2 overflow-hidden">
                            <i data-lucide="folder" class="w-4 h-4 text-amber-500 flex-shrink-0 group-hover:scale-110 transition"></i>
                            <span class="truncate">${dirName}</span>
                        </div>
                        <div class="flex items-center space-x-1">
                            <span class="text-[10px] text-slate-400 font-mono font-normal">${totalFilesInDir}</span>
                            <i data-lucide="chevron-down" class="chevron w-3.5 h-3.5 text-slate-400 transition-transform duration-200"></i>
                        </div>
                    `;

                    const subUl = buildTreeDOM(subNode);

                    dirHeader.addEventListener('click', () => {
                        subUl.classList.toggle('hidden');
                        const chevron = dirHeader.querySelector('.chevron');
                        if (chevron) chevron.classList.toggle('-rotate-90');
                    });

                    li.appendChild(dirHeader);
                    li.appendChild(subUl);
                    ul.appendChild(li);
                });

                // 2. Files in this directory
                node.files.sort((a, b) => a.name.localeCompare(b.name)).forEach(file => {
                    const li = document.createElement('li');
                    const fileBtn = document.createElement('button');
                    fileBtn.dataset.path = file.path;
                    fileBtn.className = 'w-full text-left px-2 py-1.5 rounded-md hover:bg-slate-100 dark:hover:bg-slate-800/80 flex items-center space-x-2 text-slate-600 dark:text-slate-400 hover:text-slate-900 dark:hover:text-white transition group';
                    
                    fileBtn.innerHTML = `
                        <i data-lucide="file-text" class="w-4 h-4 text-slate-400 group-hover:text-brand-500 flex-shrink-0"></i>
                        <span class="truncate font-normal" title="${file.path}">${file.name}</span>
                    `;

                    fileBtn.addEventListener('click', (e) => {
                        e.stopPropagation();
                        loadDoc(file.path);
                        document.querySelectorAll('#file-tree-container button').forEach(b => {
                            b.classList.remove('bg-brand-50', 'dark:bg-brand-950/40', 'text-brand-700', 'dark:text-brand-400', 'font-semibold');
                        });
                        fileBtn.classList.add('bg-brand-50', 'dark:bg-brand-950/40', 'text-brand-700', 'dark:text-brand-400', 'font-semibold');
                    });

                    li.appendChild(fileBtn);
                    ul.appendChild(li);
                });

                return ul;
            }

            const rootUl = buildTreeDOM(rootNode);
            rootUl.className = 'space-y-0.5';
            container.appendChild(rootUl);
            lucide.createIcons();
        }

        // Collapse / Expand All Listeners
        document.getElementById('collapse-all-btn').addEventListener('click', () => {
            document.querySelectorAll('#file-tree-container ul ul').forEach(ul => ul.classList.add('hidden'));
            document.querySelectorAll('#file-tree-container .chevron').forEach(c => c.classList.add('-rotate-90'));
        });

        document.getElementById('expand-all-btn').addEventListener('click', () => {
            document.querySelectorAll('#file-tree-container ul ul').forEach(ul => ul.classList.remove('hidden'));
            document.querySelectorAll('#file-tree-container .chevron').forEach(c => c.classList.remove('-rotate-90'));
        });

        // Load document content
        async function loadDoc(filePath) {
            try {
                const res = await fetch(`/api/content?path=${encodeURIComponent(filePath)}`);
                if (!res.ok) throw new Error('Document not found');
                const data = await res.json();
                
                currentFile = allFiles.find(f => f.path === filePath) || { path: filePath, dir: filePath.split('/').slice(0, -1).join('/') };
                window.location.hash = encodeURIComponent(filePath);

                // Update UI headers
                document.getElementById('welcome-screen').classList.add('hidden');
                document.getElementById('markdown-container').classList.remove('hidden');
                document.getElementById('content-header').classList.remove('hidden');
                document.getElementById('breadcrumb-path').innerText = filePath;
                document.getElementById('raw-markdown').value = data.content;

                renderMarkdownContent(data.content);
                generateTOC();

                // Close sidebar on mobile
                document.getElementById('sidebar').classList.add('-translate-x-full');
            } catch (err) {
                console.error(err);
                alert('Gagal memuat dokumen: ' + filePath);
            }
        }

        function renderMarkdownContent(markdownText) {
            const renderedHtml = marked.parse(markdownText);
            const container = document.getElementById('rendered-markdown');
            container.innerHTML = renderedHtml;

            // Re-render Mermaid diagrams
            setTimeout(() => {
                mermaid.run({ querySelector: '.mermaid' });
            }, 100);
        }

        function generateTOC() {
            const tocList = document.getElementById('toc-list');
            tocList.innerHTML = '';
            
            const headings = document.getElementById('rendered-markdown').querySelectorAll('h1, h2, h3');
            if (headings.length === 0) {
                tocList.innerHTML = '<span class="italic text-slate-400">Tidak ada sub-judul ditemukan</span>';
                return;
            }

            headings.forEach((heading, idx) => {
                const id = 'heading-' + idx;
                heading.id = id;

                const level = heading.tagName.toLowerCase();
                const a = document.createElement('a');
                a.href = '#' + id;
                a.className = `toc-link block py-1 truncate hover:text-brand-600 transition ${level === 'h2' ? 'pl-2' : level === 'h3' ? 'pl-4' : 'font-semibold'}`;
                a.innerText = heading.innerText;

                a.addEventListener('click', (e) => {
                    e.preventDefault();
                    heading.scrollIntoView({ behavior: 'smooth' });
                });

                tocList.appendChild(a);
            });
        }

        // Toggle View Raw / Rendered
        const rawToggleBtn = document.getElementById('raw-toggle-btn');
        rawToggleBtn.addEventListener('click', () => {
            isRawView = !isRawView;
            const rendered = document.getElementById('rendered-markdown');
            const raw = document.getElementById('raw-markdown');
            const toggleText = document.getElementById('raw-toggle-text');

            if (isRawView) {
                rendered.classList.add('hidden');
                raw.classList.remove('hidden');
                toggleText.innerText = 'View Formatted';
            } else {
                rendered.classList.remove('hidden');
                raw.classList.add('hidden');
                toggleText.innerText = 'View Raw';
            }
        });

        // Copy Path Button
        document.getElementById('copy-path-btn').addEventListener('click', () => {
            if (currentFile) {
                navigator.clipboard.writeText(currentFile.path);
                const btn = document.getElementById('copy-path-btn');
                btn.innerText = 'Copied!';
                setTimeout(() => { btn.innerHTML = '<i data-lucide="copy" class="w-3.5 h-3.5"></i><span>Copy Path</span>'; lucide.createIcons(); }, 2000);
            }
        });

        // Filter file tree in sidebar
        document.getElementById('file-filter-input').addEventListener('input', (e) => {
            const query = e.target.value.toLowerCase();
            const filtered = allFiles.filter(f => f.path.toLowerCase().includes(query) || f.title.toLowerCase().includes(query));
            renderFileTree(filtered);
        });

        // Search modal logic
        const searchModal = document.getElementById('search-modal');
        const modalInput = document.getElementById('modal-search-input');
        const quickSearchInput = document.getElementById('quick-search-input');

        function openSearchModal(initialQuery = '') {
            searchModal.classList.remove('hidden');
            modalInput.value = initialQuery;
            modalInput.focus();
            if (initialQuery) executeSearch(initialQuery);
        }

        function closeSearchModal() {
            searchModal.classList.add('hidden');
        }

        quickSearchInput.addEventListener('click', () => openSearchModal());
        document.getElementById('close-search-modal').addEventListener('click', closeSearchModal);

        window.addEventListener('keydown', (e) => {
            if (e.key === '/' && document.activeElement.tagName !== 'INPUT' && document.activeElement.tagName !== 'TEXTAREA') {
                e.preventDefault();
                openSearchModal();
            } else if (e.key === 'Escape') {
                closeSearchModal();
            }
        });

        let searchDebounce = null;
        modalInput.addEventListener('input', (e) => {
            clearTimeout(searchDebounce);
            searchDebounce = setTimeout(() => {
                executeSearch(e.target.value);
            }, 250);
        });

        async function executeSearch(query) {
            const container = document.getElementById('search-results-container');
            if (!query || query.trim().length < 2) {
                container.innerHTML = '<div class="text-center text-slate-400 text-sm py-8">Ketik minimal 2 karakter untuk mencari...</div>';
                return;
            }

            container.innerHTML = '<div class="text-center text-slate-400 text-sm py-8 animate-pulse">Mencari di seluruh dokumen...</div>';
            
            try {
                const res = await fetch(`/api/search?q=${encodeURIComponent(query)}`);
                const results = await res.json();

                if (results.length === 0) {
                    container.innerHTML = `<div class="text-center text-slate-400 text-sm py-8">Tidak ditemukan hasil untuk "${query}"</div>`;
                    return;
                }

                container.innerHTML = '';
                results.forEach(res => {
                    const item = document.createElement('div');
                    item.className = 'p-3 bg-slate-50 dark:bg-slate-800/60 hover:bg-slate-100 dark:hover:bg-slate-800 rounded-lg cursor-pointer transition space-y-1.5 border border-slate-200/60 dark:border-slate-700/50';
                    
                    let snippetsHtml = res.snippets.map(s => `
                        <div class="text-xs text-slate-500 font-mono bg-white dark:bg-slate-900 p-1.5 rounded border border-slate-200 dark:border-slate-800">
                            <span class="text-slate-400 mr-2">L${s.line}:</span>${highlightText(s.text, query)}
                        </div>
                    `).join('');

                    item.innerHTML = `
                        <div class="flex items-center justify-between">
                            <div class="flex items-center space-x-2 font-medium text-sm text-brand-600 dark:text-brand-400">
                                <i data-lucide="file-text" class="w-4 h-4"></i>
                                <span>${res.file.path}</span>
                            </div>
                            <span class="text-xs bg-brand-100 dark:bg-brand-900/50 text-brand-700 dark:text-brand-300 px-2 py-0.5 rounded-full font-semibold">
                                ${res.matches_count} matches
                            </span>
                        </div>
                        <div class="space-y-1">${snippetsHtml}</div>
                    `;

                    item.addEventListener('click', () => {
                        closeSearchModal();
                        loadDoc(res.file.path);
                    });

                    container.appendChild(item);
                });
                lucide.createIcons();
            } catch (err) {
                console.error(err);
            }
        }

        function highlightText(text, query) {
            const regex = new RegExp(`(${query.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')})`, 'gi');
            return text.replace(regex, '<mark class="bg-amber-200 dark:bg-amber-900/70 text-slate-900 dark:text-amber-100 px-0.5 rounded">$1</mark>');
        }

        // Mobile Sidebar Toggle
        document.getElementById('toggle-sidebar-btn').addEventListener('click', () => {
            document.getElementById('sidebar').classList.toggle('-translate-x-full');
        });

        // Initialize App
        fetchFiles();
    </script>
</body>
</html>
"""

class MarkdownDocsHandler(http.server.BaseHTTPRequestHandler):
    """HTTP request handler for serving markdown docs & APIs."""

    def log_message(self, format, *args):
        # Silence routine static logs for cleaner terminal output
        pass

    def do_GET(self):
        parsed_url = urllib.parse.urlparse(self.path)
        path = parsed_url.path
        query_params = urllib.parse.parse_qs(parsed_url.query)

        # Route API requests
        if path == "/api/files":
            self.send_response(200)
            self.send_header("Content-Type", "application/json; charset=utf-8")
            self.end_headers()
            files = find_md_files(BASE_DIR)
            self.wfile.write(json.dumps(files).encode('utf-8'))
            return

        elif path == "/api/content":
            file_param = query_params.get('path', [''])[0]
            if not file_param:
                self.send_error(400, "Missing path parameter")
                return
            
            # Security check for directory traversal
            target_path = os.path.abspath(os.path.join(BASE_DIR, file_param))
            if not target_path.startswith(BASE_DIR) or not os.path.exists(target_path):
                self.send_error(404, "File not found")
                return

            try:
                with open(target_path, 'r', encoding='utf-8', errors='ignore') as fp:
                    content = fp.read()
                
                self.send_response(200)
                self.send_header("Content-Type", "application/json; charset=utf-8")
                self.end_headers()
                self.wfile.write(json.dumps({"path": file_param, "content": content}).encode('utf-8'))
            except Exception as e:
                self.send_error(500, f"Error reading file: {e}")
            return

        elif path == "/api/search":
            q_param = query_params.get('q', [''])[0]
            results = full_text_search(BASE_DIR, q_param)
            self.send_response(200)
            self.send_header("Content-Type", "application/json; charset=utf-8")
            self.end_headers()
            self.wfile.write(json.dumps(results).encode('utf-8'))
            return

        # Serve SPA main index page
        elif path == "/" or path == "/index.html":
            self.send_response(200)
            self.send_header("Content-Type", "text/html; charset=utf-8")
            self.end_headers()
            self.wfile.write(HTML_TEMPLATE.encode('utf-8'))
            return

        else:
            self.send_error(404, "Not Found")

def find_available_port(start_port=8000, max_attempts=20):
    """Find an open port starting from start_port."""
    import socket
    for port in range(start_port, start_port + max_attempts):
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
            if sock.connect_ex(('localhost', port)) != 0:
                return port
    return start_port

def main():
    parser = argparse.ArgumentParser(description="Markdown Documentation Web Server")
    parser.add_argument("--port", type=int, default=8000, help="Port to bind (default: 8000)")
    parser.add_argument("--host", type=str, default="127.0.0.1", help="Host address (default: 127.0.0.1)")
    parser.add_argument("--open", action="store_true", help="Open browser automatically on launch")
    args = parser.parse_args()

    port = find_available_port(args.port)
    server_address = (args.host, port)

    class ThreadedHTTPServer(socketserver.ThreadingMixIn, http.server.HTTPServer):
        daemon_threads = True

    httpd = ThreadedHTTPServer(server_address, MarkdownDocsHandler)

    url = f"http://{args.host}:{port}"
    print("\n" + "="*60)
    print(f" 🚀 Markdown Docs Web Server is running!")
    print(f" 📍 URL: \033[1;32m{url}\033[0m")
    print(f" 📂 Root Directory: {BASE_DIR}")
    print("="*60)
    print(" Press Ctrl+C to stop the server.\n")

    if args.open:
        webbrowser.open(url)

    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        print("\n Shutting down web server...")
        httpd.shutdown()

if __name__ == "__main__":
    main()
