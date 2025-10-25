import { defineConfig } from 'vite';
import tailwindcss from '@tailwindcss/vite';
import htmlMinifier from 'vite-plugin-html-minifier';
import { viteSingleFile } from 'vite-plugin-singlefile';
import VitePluginSvgSpritemap from '@spiriit/vite-plugin-svg-spritemap';

export default defineConfig({
  plugins: [
    VitePluginSvgSpritemap('./src/icons/*.svg'),
    htmlMinifier(),
    tailwindcss(),
    viteSingleFile(),
  ],
  server: {
    host: '0.0.0.0',
  },
});
