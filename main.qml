// Constants for tooltip colors
const TOOLTIP_BACKGROUND_COLOR = '#222';
const TOOLTIP_TEXT_COLOR = '#fff';

// Function to draw the canvas with anti-aliasing enabled
function setupCanvas(canvas) {
    canvas.antialias = true;
}

// Refactored function for drawing shapes
function drawShape(ctx, shape) {
    ctx.save();
    // Set default styles
    ctx.fillStyle = shape.color || 'black';
    ctx.fillRect(shape.x, shape.y, shape.width, shape.height);
    ctx.restore();
}

// Example usage of the refactored functions
function draw() {
    const canvas = document.getElementById('myCanvas');
    setupCanvas(canvas);
    const ctx = canvas.getContext('2d');

    // Draw shapes
    drawShape(ctx, {x: 10, y: 10, width: 100, height: 100, color: 'red'});
    // Additional drawing functions can be called as needed
}