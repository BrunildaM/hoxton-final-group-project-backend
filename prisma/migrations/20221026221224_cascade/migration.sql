-- RedefineTables
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_Appointment" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "serviceId" INTEGER NOT NULL,
    "startTime" DATETIME NOT NULL,
    "endTime" DATETIME NOT NULL,
    "businessId" INTEGER NOT NULL,
    "clientId" INTEGER NOT NULL,
    CONSTRAINT "Appointment_serviceId_fkey" FOREIGN KEY ("serviceId") REFERENCES "Service" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "Appointment_clientId_fkey" FOREIGN KEY ("clientId") REFERENCES "Client" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "Appointment_businessId_fkey" FOREIGN KEY ("businessId") REFERENCES "Business" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);
INSERT INTO "new_Appointment" ("businessId", "clientId", "endTime", "id", "serviceId", "startTime") SELECT "businessId", "clientId", "endTime", "id", "serviceId", "startTime" FROM "Appointment";
DROP TABLE "Appointment";
ALTER TABLE "new_Appointment" RENAME TO "Appointment";
CREATE UNIQUE INDEX "Appointment_serviceId_key" ON "Appointment"("serviceId");
CREATE TABLE "new_BusinessHours" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "day" TEXT NOT NULL,
    "openingHours" TEXT NOT NULL,
    "closingHours" TEXT NOT NULL,
    "businessId" INTEGER NOT NULL,
    CONSTRAINT "BusinessHours_businessId_fkey" FOREIGN KEY ("businessId") REFERENCES "Business" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);
INSERT INTO "new_BusinessHours" ("businessId", "closingHours", "day", "id", "openingHours") SELECT "businessId", "closingHours", "day", "id", "openingHours" FROM "BusinessHours";
DROP TABLE "BusinessHours";
ALTER TABLE "new_BusinessHours" RENAME TO "BusinessHours";
PRAGMA foreign_key_check;
PRAGMA foreign_keys=ON;
