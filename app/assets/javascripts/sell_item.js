var allowedPaths = ['/sell', '/edit']; // List of allowed paths
if (allowedPaths.some(path => window.location.pathname.includes(path))) {
  document.addEventListener("DOMContentLoaded", function() {
    // Elements
    var dropZone = document.querySelector('.drop-zone');
    var fileInput = document.getElementById('file-input');
    var uploadBtn = document.getElementById('upload-btn');
    var fileList = document.getElementById('file-list');

    // Function to update the file list
    function updateFileList() {
      var files = Array.from(fileInput.files);
      fileList.innerHTML = '';

      if (files.length > 0) {
        var list = document.createElement('ul');

        files.forEach((file, index) => {
          var listItem = document.createElement('li');
          listItem.textContent = file.name;

          var removeButton = document.createElement('button');
          removeButton.textContent = 'Remove';
          removeButton.onclick = function() {
            files.splice(index, 1); // Remove the file from the array
            fileInput.files = createFileList(files); // Update the file input
            updateFileList(); // Update the UI
          };

          listItem.appendChild(removeButton);
          list.appendChild(listItem);
        });

        fileList.appendChild(list);
      } else {
        fileList.innerHTML = 'No files selected';
      }
    }

    // Helper function to convert an array of files into a FileList
    function createFileList(files) {
      var dataTransfer = new DataTransfer();
      files.forEach(file => dataTransfer.items.add(file));
      return dataTransfer.files;
    }

    // Click event on the upload button
    uploadBtn.addEventListener('click', function(e) {
      fileInput.click();
    });

    // Click event on the drop zone (excluding the button)
    dropZone.addEventListener('click', function(e) {
      if (e.target !== uploadBtn) {
        fileInput.click();
      }
    });

    // Drag over event on the drop zone
    dropZone.addEventListener('dragover', function(e) {
      e.preventDefault();
      dropZone.classList.add('drop-zone--over');
    });

    // Drag leave event on the drop zone
    dropZone.addEventListener('dragleave', function(e) {
      dropZone.classList.remove('drop-zone--over');
    });

    // Drop event on the drop zone
    dropZone.addEventListener('drop', function(e) {
      e.preventDefault();
      dropZone.classList.remove('drop-zone--over');

      if (e.dataTransfer.files.length) {
        fileInput.files = createFileList([...fileInput.files, ...e.dataTransfer.files]);
        updateFileList();
      }
    });

    // Change event on the file input
    fileInput.addEventListener('change', updateFileList);
  });
}
