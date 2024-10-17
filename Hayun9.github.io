<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>로봇청소기 게임</title>
    <style>
        body {
            margin: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            background-color: #f0f0f0;
            overflow: hidden;
        }
        canvas {
            background-color: #ffffff;
            border: 2px solid #000000;
        }
        #score {
            position: absolute;
            top: 20px;
            font-size: 24px;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <canvas id="gameCanvas" width="600" height="600"></canvas>
    <div id="score">점수: 30</div>

    <script>
        const canvas = document.getElementById('gameCanvas');
        const ctx = canvas.getContext('2d');
        const scoreElement = document.getElementById('score');
        
        let score = 30;
        let robot = { x: 300, y: 300, radius: 20 };
        const speed = 5;
        let icons = [];
        const iconTypes = [
            { type: 'circle', color: 'blue', points: 1 },
            { type: 'square', color: 'orange', points: 5 },
            { type: 'star', color: 'yellow', points: 10 },
            { type: 'worm', color: 'green', points: -5 },
            { type: 'spider', color: 'black', points: -10 },
            { type: 'cat', color: 'purple', points: -9999 } // 고양이 아이콘, 즉시 종료
        ];

        let keys = {};

        // 키 입력 처리
        window.addEventListener('keydown', (e) => keys[e.key] = true);
        window.addEventListener('keyup', (e) => keys[e.key] = false);

        // 아이콘 생성
        function createIcon() {
            const randomType = iconTypes[Math.floor(Math.random() * iconTypes.length)];
            const icon = {
                x: Math.random() * canvas.width,
                y: Math.random() * canvas.height,
                type: randomType.type,
                color: randomType.color,
                points: randomType.points,
                dx: (Math.random() - 0.5) * 2,
                dy: (Math.random() - 0.5) * 2
            };
            icons.push(icon);
        }

        // 일정 시간마다 아이콘 생성
        setInterval(createIcon, 2000);

        // 로봇 그리기
        function drawRobot() {
            ctx.beginPath();
            ctx.arc(robot.x, robot.y, robot.radius, 0, Math.PI * 2);
            ctx.fillStyle = 'black';
            ctx.fill();
            ctx.closePath();

            // 로봇 위에 점수 표시
            ctx.fillStyle = 'white';
            ctx.font = '16px Arial';
            ctx.fillText(score, robot.x - 10, robot.y + 5);
        }

        // 아이콘 그리기
        function drawIcons() {
            icons.forEach(icon => {
                ctx.fillStyle = icon.color;
                if (icon.type === 'circle') {
                    ctx.beginPath();
                    ctx.arc(icon.x, icon.y, 10, 0, Math.PI * 2);
                    ctx.fill();
                    ctx.closePath();
                } else if (icon.type === 'square') {
                    ctx.fillRect(icon.x - 10, icon.y - 10, 20, 20);
                } else if (icon.type === 'star') {
                    ctx.beginPath();
                    ctx.moveTo(icon.x, icon.y - 10);
                    for (let i = 0; i < 5; i++) {
                        ctx.lineTo(icon.x + 10 * Math.cos(2 * Math.PI * i / 5), icon.y + 10 * Math.sin(2 * Math.PI * i / 5));
                    }
                    ctx.fill();
                    ctx.closePath();
                } else if (icon.type === 'worm') {
                    ctx.fillRect(icon.x - 5, icon.y - 5, 10, 30);
                } else if (icon.type === 'spider') {
                    ctx.beginPath();
                    ctx.arc(icon.x, icon.y, 10, 0, Math.PI * 2);
                    ctx.fill();
                    ctx.closePath();
                } else if (icon.type === 'cat') {
                    ctx.beginPath();
                    ctx.arc(icon.x, icon.y, 15, 0, Math.PI * 2);
                    ctx.fill();
                    ctx.closePath();
                }
            });
        }

        // 로봇과 아이콘 충돌 체크
        function checkCollision() {
            icons = icons.filter(icon => {
                const dist = Math.sqrt((robot.x - icon.x) ** 2 + (robot.y - icon.y) ** 2);
                if (dist < robot.radius + 10) {
                    score += icon.points;
                    if (icon.points === -9999 || score <= 0) {
                        alert('게임 종료!');
                        document.location.reload();
                    }
                    return false;
                }
                return true;
            });
        }

        // 아이콘 움직임
        function moveIcons() {
            icons.forEach(icon => {
                icon.x += icon.dx;
                icon.y += icon.dy;

                if (icon.x < 0 || icon.x > canvas.width) icon.dx *= -1;
                if (icon.y < 0 || icon.y > canvas.height) icon.dy *= -1;
            });
        }

        // 로봇 움직임
        function moveRobot() {
            if (keys['ArrowUp'] && robot.y - robot.radius > 0) robot.y -= speed;
            if (keys['ArrowDown'] && robot.y + robot.radius < canvas.height) robot.y += speed;
            if (keys['ArrowLeft'] && robot.x - robot.radius > 0) robot.x -= speed;
            if (keys['ArrowRight'] && robot.x + robot.radius < canvas.width) robot.x += speed;
        }

        // 점수 감소
        function decreaseScore() {
            score -= 5;
            scoreElement.textContent = '점수: ' + score;
            if (score <= 0) {
                alert('게임 종료!');
                document.location.reload();
            }
        }

        setInterval(decreaseScore, 1000); // 1초마다 5점 감소

        // 게임 루프
        function gameLoop() {
            ctx.clearRect(0, 0, canvas.width, canvas.height);
            drawRobot();
            moveRobot();
            drawIcons();
            moveIcons();
            checkCollision();
            requestAnimationFrame(gameLoop);
        }

        gameLoop();
    </script>
</body>
</html>
