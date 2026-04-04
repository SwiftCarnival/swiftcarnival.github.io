<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Swift Blog Carnival</title>
    <meta name="description" content="A monthly community blogging event for Swift developers. Volunteer to host, pick a topic, and bring the community together.">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,300;9..144,500;9..144,700&family=Outfit:wght@300;400;500;600&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="grain"></div>

    <header>
        <div class="swift-mark" aria-hidden="true">
            <svg viewBox="0 0 100 100" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M88.3 76.5c.4-1.5.7-3.1.9-4.7 1.2-9.2-1.5-19.3-8.1-28.4 0 0 .1.2.2.5.5 1.4 1.8 5.6 1.4 10.3-.8 8.8-6.5 15.6-6.5 15.6s-15.9-12.4-30.8-28.7c-1.2-1.3-2.3-2.6-3.4-3.9 0 0 18 14 30.6 22.4-7-8.7-22.7-22.4-22.7-22.4s10.9 8.2 22.1 18.8C64.7 43.5 49.5 24.3 49.5 24.3c5 6 9.5 11 14.5 17-9.7-12.7-22.3-24.1-24.8-26.2-1.2-1-.5-.5.1.1 8.2 7 27.5 25.4 35.5 35.2 3.6-6.5 4.7-14.1 2.4-20.7-5.4-15.5-21.1-25-38-25.7C22.5 3.3 7.8 13.8 2.7 29.3c-3 9.3-2.4 19.2 1 27.8.3.7.5 1.1.5 1.1s-.3-1-.5-2.8c-.3-3.5.1-9.2 3.1-15.8C13 27 27.2 20.4 27.2 20.4S19 31.3 19 46.7c0 5 .8 10 2.8 14.7 1.1 2.7 2.6 5.2 4.3 7.5 6.6 8.7 17 14.5 28.8 14.8 12.8.3 24.3-5.9 31.5-15.4.7-1 2-3 1.9-3.2-.1.5-6.5 9.7-17.6 14.2-7 2.8-14.8 2.9-21.5.7 9.4 1.4 19.7-1.2 27.4-7.1 4.4-3.4 8-7.7 10.5-12.5.3-.6 1-2.1 1.2-2.5v18.6z" fill="currentColor"/>
            </svg>
        </div>
        <div class="header-content">
            <h1>Swift Blog<br><span class="accent">Carnival</span></h1>
            <p class="tagline">A monthly community blogging event<br>for Swift developers.</p>
        </div>
    </header>

    <main>
        {{FEATURED}}

        <section class="editions-section" aria-label="All Editions">
            <h2 class="section-title">Editions</h2>
            {{TABLE}}
        </section>

        <section class="volunteer" aria-label="Volunteer to host">
            <div class="volunteer-inner">
                <h2>Want to host?</h2>
                <p>Pick a month, choose a topic, rally the community.</p>
                <a href="https://github.com/SwiftCarnival/swiftcarnival.github.io/issues/new?template=volunteer-to-host.yml" class="cta">
                    Volunteer <span aria-hidden="true">&rarr;</span>
                </a>
            </div>
        </section>
    </main>

    <footer>
        <div class="footer-inner">
            <span class="footer-logo">Swift Blog Carnival</span>
            <a href="https://github.com/SwiftCarnival/swiftcarnival.github.io">GitHub</a>
        </div>
    </footer>
</body>
</html>
