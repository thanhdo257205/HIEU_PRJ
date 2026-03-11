/* ═══════════════════════════════════════════════ */
/*   PhoneShop - Interactive Effects               */
/* ═══════════════════════════════════════════════ */

// Scroll Animation Observer
document.addEventListener('DOMContentLoaded', function() {

    // Animate elements when they scroll into view
    const observer = new IntersectionObserver(function(entries) {
        entries.forEach(function(entry) {
            if (entry.isIntersecting) {
                entry.target.classList.add('visible');
                observer.unobserve(entry.target);
            }
        });
    }, {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    });

    document.querySelectorAll('.animate-on-scroll').forEach(function(el) {
        observer.observe(el);
    });

    // Stagger animation for product cards
    document.querySelectorAll('.product-grid').forEach(function(grid) {
        var cards = grid.querySelectorAll('.product-card');
        cards.forEach(function(card, index) {
            card.style.opacity = '0';
            card.style.transform = 'translateY(30px)';
            card.style.transition = 'opacity 0.5s ease ' + (index * 0.1) + 's, transform 0.5s ease ' + (index * 0.1) + 's';
        });

        var gridObserver = new IntersectionObserver(function(entries) {
            entries.forEach(function(entry) {
                if (entry.isIntersecting) {
                    var cards = entry.target.querySelectorAll('.product-card');
                    cards.forEach(function(card) {
                        card.style.opacity = '1';
                        card.style.transform = 'translateY(0)';
                    });
                    gridObserver.unobserve(entry.target);
                }
            });
        }, { threshold: 0.1 });

        gridObserver.observe(grid);
    });

    // Navbar scroll effect
    var navbar = document.querySelector('.navbar');
    if (navbar) {
        var lastScroll = 0;
        window.addEventListener('scroll', function() {
            var currentScroll = window.pageYOffset;
            if (currentScroll > 100) {
                navbar.style.boxShadow = '0 4px 20px rgba(0,0,0,0.08)';
                navbar.style.background = 'rgba(255,255,255,0.95)';
                navbar.style.backdropFilter = 'blur(16px)';
            } else {
                navbar.style.boxShadow = 'none';
                navbar.style.background = 'var(--white)';
                navbar.style.backdropFilter = 'none';
            }
            lastScroll = currentScroll;
        });
    }

    // Hero features hover effect
    document.querySelectorAll('.hero-feature-item').forEach(function(item, index) {
        item.style.opacity = '0';
        item.style.transform = 'translateX(20px)';
        setTimeout(function() {
            item.style.transition = 'all 0.4s ease';
            item.style.opacity = '1';
            item.style.transform = 'translateX(0)';
        }, 500 + index * 100);
    });

    // Brand bar scroll animation
    document.querySelectorAll('.brand-bar-item').forEach(function(item, index) {
        item.style.opacity = '0';
        item.style.transform = 'translateY(10px)';
        setTimeout(function() {
            item.style.transition = 'all 0.4s ease';
            item.style.opacity = '1';
            item.style.transform = 'translateY(0)';
        }, 300 + index * 100);
    });

    // Smooth button click ripple effect
    document.querySelectorAll('.btn-primary, .add-cart-btn').forEach(function(btn) {
        btn.addEventListener('click', function(e) {
            var ripple = document.createElement('span');
            ripple.style.position = 'absolute';
            ripple.style.borderRadius = '50%';
            ripple.style.background = 'rgba(255,255,255,0.4)';
            ripple.style.width = '100px';
            ripple.style.height = '100px';
            ripple.style.transform = 'translate(-50%, -50%) scale(0)';
            ripple.style.animation = 'ripple 0.6s ease-out';
            ripple.style.pointerEvents = 'none';

            var rect = btn.getBoundingClientRect();
            ripple.style.left = (e.clientX - rect.left) + 'px';
            ripple.style.top = (e.clientY - rect.top) + 'px';

            btn.style.position = 'relative';
            btn.style.overflow = 'hidden';
            btn.appendChild(ripple);

            setTimeout(function() {
                ripple.remove();
            }, 600);
        });
    });

    // Add ripple keyframe if not exists
    if (!document.querySelector('#ripple-style')) {
        var style = document.createElement('style');
        style.id = 'ripple-style';
        style.textContent = '@keyframes ripple { to { transform: translate(-50%, -50%) scale(3); opacity: 0; } }';
        document.head.appendChild(style);
    }
});
