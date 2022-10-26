/*
  Warnings:

  - You are about to drop the column `businessHoursId` on the `Business` table. All the data in the column will be lost.
  - Added the required column `businessId` to the `BusinessHours` table without a default value. This is not possible if the table is not empty.
  - Added the required column `name` to the `Category` table without a default value. This is not possible if the table is not empty.
  - Added the required column `password` to the `Client` table without a default value. This is not possible if the table is not empty.

*/
-- RedefineTables
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_Business" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "name" TEXT NOT NULL,
    "phoneNumber" TEXT,
    "categoryId" INTEGER NOT NULL,
    "businessOwnerId" INTEGER NOT NULL,
    CONSTRAINT "Business_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES "Category" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "Business_businessOwnerId_fkey" FOREIGN KEY ("businessOwnerId") REFERENCES "BusinessOwner" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);
INSERT INTO "new_Business" ("businessOwnerId", "categoryId", "id", "name", "phoneNumber") SELECT "businessOwnerId", "categoryId", "id", "name", "phoneNumber" FROM "Business";
DROP TABLE "Business";
ALTER TABLE "new_Business" RENAME TO "Business";
CREATE UNIQUE INDEX "Business_businessOwnerId_key" ON "Business"("businessOwnerId");
CREATE TABLE "new_BusinessHours" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "day" TEXT NOT NULL,
    "openingHours" TEXT NOT NULL,
    "closingHours" TEXT NOT NULL,
    "businessId" INTEGER NOT NULL,
    CONSTRAINT "BusinessHours_businessId_fkey" FOREIGN KEY ("businessId") REFERENCES "Business" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_BusinessHours" ("closingHours", "day", "id", "openingHours") SELECT "closingHours", "day", "id", "openingHours" FROM "BusinessHours";
DROP TABLE "BusinessHours";
ALTER TABLE "new_BusinessHours" RENAME TO "BusinessHours";
CREATE TABLE "new_Category" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "name" TEXT NOT NULL
);
INSERT INTO "new_Category" ("id") SELECT "id" FROM "Category";
DROP TABLE "Category";
ALTER TABLE "new_Category" RENAME TO "Category";
CREATE TABLE "new_Client" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "name" TEXT NOT NULL,
    "avatar" TEXT,
    "email" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "phoneNumber" TEXT NOT NULL
);
INSERT INTO "new_Client" ("avatar", "email", "id", "name", "phoneNumber") SELECT "avatar", "email", "id", "name", "phoneNumber" FROM "Client";
DROP TABLE "Client";
ALTER TABLE "new_Client" RENAME TO "Client";
CREATE UNIQUE INDEX "Client_email_key" ON "Client"("email");
PRAGMA foreign_key_check;
PRAGMA foreign_keys=ON;
