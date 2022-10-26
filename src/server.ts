import express from "express";
import cors from "cors";
import { PrismaClient } from "@prisma/client";
import { generateToken, getCurrentUser, hash, verify } from "./auth";

const app = express();
app.use(cors());
// app.options("*", cors());
app.use(express.json());
const prisma = new PrismaClient();

const port = 4000;

//Log-in a business owner that already exists with it's credentials
app.post("/sign-in/businessOwner", async (req, res) => {
  try {
    const { email, password } = req.body;

    //check for any possible error
    const errors: string[] = [];

    if (typeof email !== "string")
      errors.push("Email not provided or not a string!");

    if (typeof password !== "string")
      errors.push("Password not provided or not a string!");

    if (errors.length > 0) {
      return res.status(400).send({ errors });
    }

    //Check if they email exists on our db
    const businessOwner = await prisma.businessOwner.findUnique({
      where: { email },
      include: {
        business: { include: { appointments: true, businessHours: true } },
      },
    });

    //Check if the e-mail and password match
    if (businessOwner && verify(password, businessOwner.password)) {
      const token = generateToken(businessOwner.id);

      res.send({ user: businessOwner, token });
    } else {
      res.status(400).send({ errors: ["Wrong credentials!"] });
    }
  } catch (error) {
    //@ts-ignore
    res.status(400).send({ errors: [error.message] });
  }
});

//Log-in a client that already exists with it's credentials
app.post("/sign-in/client", async (req, res) => {
  try {
    const { email, password } = req.body;

    //check for any possible error
    const errors: string[] = [];

    if (typeof email !== "string")
      errors.push("Email not provided or not a string!");

    if (typeof password !== "string")
      errors.push("Password not provided or not a string!");

    if (errors.length > 0) {
      return res.status(400).send({ errors });
    }

    //Check if they email exists on our db
    const client = await prisma.client.findUnique({
      where: { email },
      include: {
        appointments: true,
      },
    });

    //Check if the e-mail and password match
    if (client && verify(password, client.password)) {
      const token = generateToken(client.id);

      res.send({ user: client, token });
    } else {
      res.status(400).send({ errors: ["Wrong credentials!"] });
    }
  } catch (error) {
    //@ts-ignore
    res.status(400).send({ errors: [error.message] });
  }
});

// //Create a new account for users
// app.post("/sign-up/businessOwner", async (req, res) => {
//   const { email, password, age, name, avatar, business: {name: businessName, phoneNumber, category: {name: categoryName} } } = req.body;
//   try {
//     //Check if the email is already in our db
//     const existingUser = await prisma.businessOwner.findUnique({
//       where: { email },
//     });

//     //Checking all possible errors
//     const errors: string[] = [];
//     if (typeof email !== "string")
//       errors.push("Email not provided or not a string");

//     if (typeof password !== "string")
//       errors.push("Password not provided or not a string");

//     if (typeof name !== "string")
//       errors.push("Name not provided or not a string");

//     if (typeof age !== "number")
//       errors.push("Age not provided or not a number");

//     //Don't allow a user under 18 to create an account
//     if (age < 18)
//       errors.push("You can't create an account if you are under 18!");

//     if (errors.length > 0) {
//       return res.status(400).send({ errors });
//     }

//     //Make sure they don't create two accounts with the same email
//     if (existingUser) {
//       return res.status(400).send({ errors: ["User already exists!"] });
//     }

//     const userData = {
//       age,
//       avatar,
//       name,
//       email,
//       password: hash(password),
//     };

//     const businessData = {
//       name: req.body.businessName,
//       category: req.body.category,

//     };

//     const newBusinessOwner = await prisma.businessOwner.create({
//       data: { ...userData, business: { create: businessData } },
//     });

//     const token = generateToken(newBusinessOwner.id);
//     res.send({ newBusinessOwner, token });
//   } catch (error) {
//     //@ts-ignore
//     res.status(400).send({ errors: [error.message] });
//   }
// });

app.get("/validate", async (req, res) => {
  try {
    //get the token
    const token = req.headers.authorization;
    if (token) {
      const user = await getCurrentUser(token);
      //check if there is a user with this token
      if (user) {
        const newToken = generateToken(user.id);
        //send the user with a new token
        res.send({ user, token: newToken });
      } else {
        //check all possible errors
        res.status(400).send({ errors: ["Invalid token!"] });
      }
    } else {
      res.status(400).send({ errors: ["Token not provided "] });
    }
  } catch (error) {
    //@ts-ignore
    res.status(400).send({ errors: [error.message] });
  }
});

app.listen(port, () => {
  console.log(`App is running: http://localhost:${port}`);
});
