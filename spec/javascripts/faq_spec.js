describe("toggleAnswer", function() {
  beforeEach(function() {
    // Create a div element with id "answer-1" for testing
    const answerDiv = document.createElement("div");
    answerDiv.id = "answer-1";
    answerDiv.style.display = "none"; // Initial state is hidden
    document.body.appendChild(answerDiv);
  });

  afterEach(function() {
    // Clean up: remove the created element
    const answerDiv = document.getElementById("answer-1");
    if (answerDiv) {
      document.body.removeChild(answerDiv);
    }
  });

  it("should toggle the display from 'none' to 'block'", function() {
    // Call the toggleAnswer function
    toggleAnswer(1);

    // Expect the display style to be "block" after the function call
    expect(document.getElementById("answer-1").style.display).toBe("block");
  });

  it("should toggle the display from 'block' to 'none'", function() {
    // Set the initial display style to "block"
    document.getElementById("answer-1").style.display = "block";

    // Call the toggleAnswer function
    toggleAnswer(1);

    // Expect the display style to be "none" after the function call
    expect(document.getElementById("answer-1").style.display).toBe("none");
  });
});
