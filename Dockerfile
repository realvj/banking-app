FROM node:18
 
WORKDIR /app
 
# Copy package files first (better layer caching)
COPY package.json package-lock.json* ./
 
RUN npm install
 
# Copy rest of the application
COPY . .
 
EXPOSE 3000
 
CMD ["node", "app.js"]
