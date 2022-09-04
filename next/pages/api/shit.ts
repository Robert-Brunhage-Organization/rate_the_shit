// Next.js API route support: https://nextjs.org/docs/api-routes/introduction
import type { NextApiRequest, NextApiResponse } from "next";
import { PrismaClient, Shit } from "@prisma/client";

const prisma = new PrismaClient();

type Error = {
  error: string;
  success: boolean;
};

type Payload = {
  value: number;
  name: string;
};

export default async function handler(
  req: NextApiRequest,
  res: NextApiResponse<Shit | Error>
) {
  if (req.method === "POST") {
    return await vote(req, res);
  } else {
    return res.status(405).json({ error: "eat shit", success: false });
  }
}

async function vote(req: NextApiRequest, res: NextApiResponse<Shit | Error>) {
  const body: Payload = req.body;
  try {
    const upsertShit = await prisma.shit.upsert({
      where: {
        name: body.name,
      },
      update: {
        rating: body.value,
        name: body.name,
      },
      create: {
        rating: body.value!,
        name: body.name!,
      },
    });
    return res.status(200).json(upsertShit);
  } catch (error) {
    console.error("Request error", error);
    res.status(500).json({ error: "Error creating shit", success: false });
  }
}
