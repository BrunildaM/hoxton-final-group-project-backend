/*
  Warnings:

  - You are about to drop the column `endTime` on the `Appointment` table. All the data in the column will be lost.
  - You are about to drop the column `startTime` on the `Appointment` table. All the data in the column will be lost.

*/
-- RedefineTables
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_Appointment" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "serviceId" INTEGER NOT NULL,
    "title" TEXT,
    "startDate" TEXT,
    "endDate" TEXT,
    "businessId" INTEGER NOT NULL,
    "clientId" INTEGER NOT NULL,
    CONSTRAINT "Appointment_serviceId_fkey" FOREIGN KEY ("serviceId") REFERENCES "Service" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "Appointment_clientId_fkey" FOREIGN KEY ("clientId") REFERENCES "Client" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "Appointment_businessId_fkey" FOREIGN KEY ("businessId") REFERENCES "Business" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);
INSERT INTO "new_Appointment" ("businessId", "clientId", "id", "serviceId") SELECT "businessId", "clientId", "id", "serviceId" FROM "Appointment";
DROP TABLE "Appointment";
ALTER TABLE "new_Appointment" RENAME TO "Appointment";
CREATE UNIQUE INDEX "Appointment_serviceId_key" ON "Appointment"("serviceId");
PRAGMA foreign_key_check;
PRAGMA foreign_keys=ON;
