const dashboardItem = document.querySelectorAll('.dashboard-nav-item');

  dashboardItem.forEach(item => {
    item.addEventListener('click', () => {
      // Remove active class from all items
      dashboardItem.forEach(i => i.classList.remove('active'));
      // Add active class to clicked item
      item.classList.add('active');
    });
});



// =============================== setting toggle section

const profile = document.getElementById('body-navigator');
const profileItem = document.getElementById('setting-items');

// Toggle dropdown when clicking on profile
profile.addEventListener('click', (event) => {
    event.stopPropagation(); // Prevents the event from bubbling to the document
    profileItem.style.display = profileItem.style.display === "block" ? "none" : "block";
});

// Hide dropdown when clicking outside of it
document.addEventListener('click', (event) => {
    // Check if the click is not on the dropdown or the profile pic
    if (!profile.contains(event.target) && !profileItem.contains(event.target)) {
        profileItem.style.display = "none";
    }
});




// ================================================================= mobile bar section 
const sidebar = document.getElementById('sidebars');
const bars = document.getElementById('bars');

bars.addEventListener('click', () => {
    sidebar.classList.toggle('show');
    bars.classList.toggle('show');
    document.body.classList.toggle('no-scroll');
});

// Close sidebar when clicking outside of it
document.addEventListener('click', (event) => {
    const isClickInsideSidebar = sidebar.contains(event.target);
    const isClickOnBars = bars.contains(event.target);

    if (!isClickInsideSidebar && !isClickOnBars && sidebar.classList.contains('show')) {
        sidebar.classList.remove('show');
        bars.classList.remove('show');
        document.body.classList.remove('no-scroll');
    }
});