const XLSX = require('xlsx')
const FS = require('fs')
const SECRET = require('./secrets.json')
const { google } = require('googleapis')
const credentials = {
    client_email: SECRET.Email,
    private_key: SECRET.Key,
}
const auth = new google.auth.GoogleAuth({
    credentials,
    scopes: ['https://www.googleapis.com/auth/drive.file'],
});
const drive = google.drive({ version: 'v3', auth });


function CreateSheet(cid, time, data) {
    return new Promise((resolve, reject) => {
        const workbook = XLSX.utils.book_new()
        const worksheet = XLSX.utils.json_to_sheet(data)
        XLSX.utils.book_append_sheet(workbook, worksheet, 'Transactions')
        XLSX.writeFile(workbook, `data/${cid}_${time}.xlsx`)
        drive.files.create(
            {
                resource: {
                    name: `${cid}_${time}.xlsx`,
                    mimeType: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
                    parents: [SECRET.Folder],
                },
                media: {
                    mimeType: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
                    body: FS.createReadStream(`data/${cid}_${time}.xlsx`),
                },
            },
            (err, res) => {
                if (err) {
                    reject(new Error(`Error uploading file to Google Drive:\n ${err}`));
                    return;
                }
                resolve(`https://drive.google.com/uc?export=download&id=${res.data.id}`)
            }
        )
    })
}

async function myFunction(cid, time, data) {
    try {
        const result = await CreateSheet(cid, time, data);
        return result
    } catch (error) {
        console.error('Promise rejected:', error);
        return false
    }
}

exports('CreateSheet', myFunction);

