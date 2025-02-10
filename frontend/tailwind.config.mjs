/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./pages/**/*.{js,ts,jsx,tsx,mdx}",
    "./components/**/*.{js,ts,jsx,tsx,mdx}",
    "./app/**/*.{js,ts,jsx,tsx,mdx}",
  ],
  theme: {
    extend: {
      colors: {
        background: "var(--background)",
        foreground: "var(--foreground)",
      },
      backgroundImage: {
        'faucet': "url('/assets/background.gif')",
      },
      backgroundSize: {
        'auto': 'auto',
        'cover': 'cover',
        'contain': 'contain',
        '50%': '50%',
        '16': '4rem',
        'full': '100%',
      },
      backgroundRepeat: {
        'repeat': 'repeat',
        'no-repeat': 'no-repeat',
        'repeat-x': 'repeat-x',
        'repeat-y': 'repeat-y',
        'space': 'space',
        'round': 'round',
      },
      // fontFamily: {
      //   wq: ['wq'],  // 使用刚才定义的字体名称
      // },
      animation: {
        'marquee': 'marquee 10s linear infinite', // 设置动画
      },
      keyframes: {
        marquee: {
          '0%': {
            transform: 'translateX(100%)', // 从右往左
          },
          '100%': {
            transform: 'translateX(-100%)', // 到达左边
          },
        },
      },
    },
  },
  plugins: [],
};
