-- CreateTable
CREATE TABLE `Adiciones` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `nombre` VARCHAR(191) NOT NULL,
    `precio` INTEGER NOT NULL,
    `tipo` VARCHAR(191) NOT NULL,

    UNIQUE INDEX `Adiciones_nombre_key`(`nombre`),
    UNIQUE INDEX `Adiciones_tipo_key`(`tipo`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `OrderProductsAdiciones` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `cantidad` INTEGER NOT NULL,
    `orderproducts_id` INTEGER NOT NULL,
    `adiciones_id` INTEGER NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `OrderProductsAdiciones` ADD CONSTRAINT `OrderProductsAdiciones_orderproducts_id_fkey` FOREIGN KEY (`orderproducts_id`) REFERENCES `OrderProducts`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `OrderProductsAdiciones` ADD CONSTRAINT `OrderProductsAdiciones_adiciones_id_fkey` FOREIGN KEY (`adiciones_id`) REFERENCES `Adiciones`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;
