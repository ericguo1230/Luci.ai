const axios = require('axios').default;
const {PrismaClient} = require("@prisma/client")

const prisma = new PrismaClient();

axios.post('/user', {
    action: "get-swp-report-options",
    company: "Tridel",
    area: "default-vaughan",
    credential: "7b22757365726e616d65223a2265766537406c7563692e6169222c2270617373776f7264223a2238303137313036386430393338313461222c226e6f6e6365223a223832656264656464303562386362663164636231383636366666363638663963222c2261757468546167223a226164646236666366626438653339663237316135313136626131396639626130227d"
}).then(async function (res) {
    const ponds = await prisma.Pond.findMany({
        where:{
            area_uuid: area
        },
        select: {
            uuid: true,
            name_id: true,
            name: true
        }
    })
    res.log(ponds);
}).catch(function (err) {
    console.log(error);
})
