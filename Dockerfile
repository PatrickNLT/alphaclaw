FROM node:22-slim
RUN apt-get update && apt-get install -y git curl procps cron tini && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci
COPY bin/ ./bin/
COPY lib/ ./lib/
COPY scripts/ ./scripts/
COPY tailwind.config.cjs ./
RUN npm run build:ui && npm prune --omit=dev
RUN ln -s /app/bin/alphaclaw.js /usr/local/bin/alphaclaw && chmod +x /app/bin/alphaclaw.js \
 && ln -s /app/node_modules/.bin/openclaw /usr/local/bin/openclaw
ENV ALPHACLAW_ROOT_DIR=/data
EXPOSE 3000
ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["node", "bin/alphaclaw.js", "start"]
