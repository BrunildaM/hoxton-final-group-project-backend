/*
  Warnings:

  - You are about to drop the `User` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the column `userId` on the `Business` table. All the data in the column will be lost.
  - Added the required column `businessHoursId` to the `Business` table without a default value. This is not possible if the table is not empty.
  - Added the required column `businessOwnerId` to the `Business` table without a default value. This is not possible if the table is not empty.

*/
-- DropIndex
DROP INDEX "User_email_key";

-- DropTable
PRAGMA foreign_keys=off;
DROP TABLE "User";
PRAGMA foreign_keys=on;

-- CreateTable
CREATE TABLE "BusinessOwner" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "email" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "avatar" TEXT,
    "age" INTEGER NOT NULL
);

-- RedefineTables
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_Business" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "name" TEXT NOT NULL,
    "phoneNumber" TEXT,
    "categoryId" INTEGER NOT NULL,
    "businessOwnerId" INTEGER NOT NULL,
    "businessHoursId" INTEGER NOT NULL,
    CONSTRAINT "Business_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES "Category" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "Business_businessOwnerId_fkey" FOREIGN KEY ("businessOwnerId") REFERENCES "BusinessOwner" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "Business_businessHoursId_fkey" FOREIGN KEY ("businessHoursId") REFERENCES "BusinessHours" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_Business" ("categoryId", "id", "name", "phoneNumber") SELECT "categoryId", "id", "name", "phoneNumber" FROM "Business";
DROP TABLE "Business";
ALTER TABLE "new_Business" RENAME TO "Business";
CREATE UNIQUE INDEX "Business_businessOwnerId_key" ON "Business"("businessOwnerId");
PRAGMA foreign_key_check;
PRAGMA foreign_keys=ON;

-- CreateIndex
CREATE UNIQUE INDEX "BusinessOwner_email_key" ON "BusinessOwner"("email");
