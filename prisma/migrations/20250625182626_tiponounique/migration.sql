/*
  Warnings:

  - You are about to drop the column `userId` on the `category` table. All the data in the column will be lost.
  - Added the required column `userId` to the `Order` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE `category` DROP FOREIGN KEY `Category_userId_fkey`;

-- DropIndex
DROP INDEX `Adiciones_tipo_key` ON `adiciones`;

-- DropIndex
DROP INDEX `Category_userId_fkey` ON `category`;

-- AlterTable
ALTER TABLE `category` DROP COLUMN `userId`;

-- AlterTable
ALTER TABLE `order` ADD COLUMN `userId` INTEGER NOT NULL;

-- AddForeignKey
ALTER TABLE `Order` ADD CONSTRAINT `Order_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `User`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;
