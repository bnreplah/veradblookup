document.getElementById('searchButton').addEventListener('click', function() {
    const query = document.getElementById('searchInput').value;
    if (query) {
      const searchUrl = `https://sca.analysiscenter.veracode.com/vulnerability-database/search#query=${encodeURIComponent(query)}`;
      chrome.tabs.create({ url: searchUrl });
    }
  });
  