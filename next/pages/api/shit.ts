// Next.js API route support: https://nextjs.org/docs/api-routes/introduction
import type { NextApiRequest, NextApiResponse } from "next";
import { PrismaClient, Shit } from "@prisma/client";

const prisma = new PrismaClient();

type Error = {
  error: string;
};

type Payload = {
  value: number;
  name: string;
};

export default async function handler(
  req: NextApiRequest,
  res: NextApiResponse<Shit | Shit[] | string | Error>
) {

  // This will allow OPTIONS request
  if (req.method === "OPTIONS") {
    return res.status(200).send('ok!');
  }

  if (req.method === "POST") {
    return await vote(req, res);
  } else if (req.method === "GET") {
    return await get(res);
  } else {
    return res.status(405).json({ error: "eat shit" });
  }
}

async function vote(req: NextApiRequest, res: NextApiResponse<Shit | Error>) {
  const body: Payload = req.body;

  async function increment(): Promise<Shit> {
    const upsertShit = await prisma.shit.upsert({
      where: {
        name: body.name,
      },
      update: {
        positiveRating: {
          increment: 1
        },
      },
      create: {
        positiveRating: 1,
        negativeRating: 0,
        skipRating: 0,
        name: body.name,
      },
    });

    return upsertShit;
  }

  async function decrement(): Promise<Shit> {
    const upsertShit = await prisma.shit.upsert({
      where: {
        name: body.name,
      },
      update: {
        negativeRating: {
          increment: 1
        },
      },
      create: {
        positiveRating: 0,
        negativeRating: 1,
        skipRating: 0,
        name: body.name,
      },
    });

    return upsertShit;
  }

  async function none(): Promise<Shit> {
    const upsertShit = await prisma.shit.upsert({
      where: {
        name: body.name,
      },
      update: {
        skipRating: {
          increment: 1
        },
      },
      create: {
        positiveRating: 0,
        negativeRating: 0,
        skipRating: 1,
        name: body.name,
      },
    });

    return upsertShit;
  }

  try {
    let upsertShit: Shit;
    console.log(body);
    let count = await prisma.shit.count({ where: { name: body.name } });
    if (count === 0) {
      return res.status(500).json({ error: 'You little S***' });
    };
    if (body.value > 0) {
      upsertShit = await increment();
    } else if (body.value < 0) {
      upsertShit = await decrement();
    } else {
      upsertShit = await none();
    }
    return res.status(200).json(upsertShit);
  } catch (error) {
    console.error("Request error", error);
    return res.status(500).json({ error: "Error creating shit" });
  }
}


async function get(res: NextApiResponse<Shit[] | Error>) {
  try {
    // No clue how to order by percentage of positive and negative rating
    let shits = await prisma.shit.findMany();
    return res.status(200).json(shits);
  } catch (error) {
    console.error("Request error", error);
    res.status(500).json({ error: "Error getting all the shit" });
  }
}
