function toggleAnswer(index) {
  let answer = document.getElementById('answer-' + index);
  if (answer.style.display === 'none') {
    answer.style.display = 'block';
  } else {
    answer.style.display = 'none';
  }
}
