<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>스네이크 게임</title>
    <style>
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            background-color: #f0f0f0;
        }
        #gameCanvas {
            border: 2px solid #000;
        }
    </style>
</head>
<body>
    <canvas id="gameCanvas" width="400" height="400"></canvas>

    <script>
        const canvas = document.getElementById('gameCanvas');
        const ctx = canvas.getContext('2d');

        const GRID_SIZE = 20;
        const SNAKE_COLOR = '#4CAF50';
        const FOOD_COLOR = '#FF5722';

        let snake = [
            {x: 200, y: 200},
            {x: 180, y: 200},
            {x: 160, y: 200},
        ];

        let dx = GRID_SIZE;
        let dy = 0;

        let food = getRandomFood();

        let score = 0;

        document.addEventListener('keydown', changeDirection);

        function main() {
            if (gameOver()) {
                alert('게임 오버! 점수: ' + score);
                return;
            }

            setTimeout(function onTick() {
                clearCanvas();
                moveSnake();
                drawFood();
                drawSnake();
                main();
            }, 100)
        }

        function clearCanvas() {
            ctx.fillStyle = '#FFF';
            ctx.fillRect(0, 0, canvas.width, canvas.height);
        }

        function drawSnake() {
            snake.forEach(drawSnakePart);
        }

        function drawSnakePart(snakePart) {
            ctx.fillStyle = SNAKE_COLOR;
            ctx.fillRect(snakePart.x, snakePart.y, GRID_SIZE, GRID_SIZE);
        }

        function drawFood() {
            ctx.fillStyle = FOOD_COLOR;
            ctx.fillRect(food.x, food.y, GRID_SIZE, GRID_SIZE);
        }

        function moveSnake() {
            const head = {x: snake[0].x + dx, y: snake[0].y + dy};
            snake.unshift(head);

            if (head.x === food.x && head.y === food.y) {
                score += 10;
                food = getRandomFood();
            } else {
                snake.pop();
            }
        }

        function changeDirection(event) {
            const LEFT_KEY = 37;
            const RIGHT_KEY = 39;
            const UP_KEY = 38;
            const DOWN_KEY = 40;

            const keyPressed = event.keyCode;
            const goingUp = dy === -GRID_SIZE;
            const goingDown = dy === GRID_SIZE;
            const goingRight = dx === GRID_SIZE;
            const goingLeft = dx === -GRID_SIZE;

            if (keyPressed === LEFT_KEY && !goingRight) {
                dx = -GRID_SIZE;
                dy = 0;
            }
            if (keyPressed === UP_KEY && !goingDown) {
                dx = 0;
                dy = -GRID_SIZE;
            }
            if (keyPressed === RIGHT_KEY && !goingLeft) {
                dx = GRID_SIZE;
                dy = 0;
            }
            if (keyPressed === DOWN_KEY && !goingUp) {
                dx = 0;
                dy = GRID_SIZE;
            }
        }

        function getRandomFood() {
            return {
                x: Math.floor(Math.random() * (canvas.width / GRID_SIZE)) * GRID_SIZE,
                y: Math.floor(Math.random() * (canvas.height / GRID_SIZE)) * GRID_SIZE
            }
        }

        function gameOver() {
            for (let i = 4; i < snake.length; i++) {
                if (snake[i].x === snake[0].x && snake[i].y === snake[0].y) return true;
            }
            const hitLeftWall = snake[0].x < 0;
            const hitRightWall = snake[0].x > canvas.width - GRID_SIZE;
            const hitTopWall = snake[0].y < 0;
            const hitBottomWall = snake[0].y > canvas.height - GRID_SIZE;
            return hitLeftWall || hitRightWall || hitTopWall || hitBottomWall;
        }

        main();
    </script>
</body>
</html>
