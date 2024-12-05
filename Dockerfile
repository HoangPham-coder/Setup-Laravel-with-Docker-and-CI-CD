# Sử dụng PHP 8.1 làm base image
FROM php:8.1-fpm

# Cập nhật và cài đặt các thư viện hệ thống cần thiết
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    curl \
    git \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Cài đặt Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Thiết lập thư mục làm việc
WORKDIR /var/www

# Sao chép toàn bộ mã nguồn Laravel vào container
COPY . /var/www

# Phân quyền thư mục
RUN chown -R www-data:www-data /var/www \
    && chmod -R 755 /var/www

# Mở port cho PHP-FPM
EXPOSE 9000

# Lệnh chạy mặc định
CMD ["php-fpm"]
