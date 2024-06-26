# Ustawienie obrazu bazowego
FROM node:20.11.1-alpine

# Ustawienie zmiennych środowiskowych dla pnpm
ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"

# Włączenie corepack do zarządzania pnpm
RUN corepack enable

# Kopiowanie zawartości lokalnego katalogu do obrazu
COPY . .

# Instalacja turbo globalnie za pomocą pnpm
RUN pnpm install --global turbo

# Argument APP_NAME umożliwiający określenie aplikacji podczas budowania obrazu
ARG APP_NAME
ENV APP_NAME=${APP_NAME}

# Przycięcie zależności tylko dla określonej aplikacji
RUN turbo prune ${APP_NAME} --docker

# Instalacja zależności tylko dla określonej aplikacji
RUN --mount=type=cache,id=pnpm,target=/pnpm/store pnpm install --frozen-lockfile --filter=${APP_NAME}

# Ustawienie polecenia startowego, zależne od APP_NAME
CMD ["pnpm", "dev", "--filter=${APP_NAME}"]
