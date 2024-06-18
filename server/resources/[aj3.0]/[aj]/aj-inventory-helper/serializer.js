const zlib = require('node:zlib');

const options = {level: 9}

// const TimeAllowed = 60 * 60 * 24 * 1;

const Encode = (data) => {
    const string = JSON.stringify(data);
    const compressedData = zlib.deflateSync(string, options);
    return compressedData.toString('base64')
}

const Decode = (data) => {
    return JSON.parse(zlib.inflateSync(Buffer.from(data, 'base64')).toString())
}

const Convert = (data, decayRate) => {
    const start = Date.now()
    const currentTime = Math.floor(Date.now() / 1000);
    const timeExtra = Math.ceil(86400 * decayRate);
    const metadata2 = data;
    const metadata = Decode(metadata2)
    let finalQuality = 100;
    for (let i = 0; i < metadata.length; i++) {
        const meta = metadata[i];
        const startDate = meta.created;
        console.log("Create:", meta.created)
        console.log(currentTime, startDate, timeExtra)
        console.log(currentTime- startDate)
        console.log((currentTime- startDate)/timeExtra)
        let percentDone = 100 - Math.ceil(((currentTime - startDate) / timeExtra) * 100);
        console.log(percentDone,'%')

        if (decayRate === 0) {
            percentDone = 100;
        }
        if (percentDone < 0) {
            percentDone = 0;
        }


        meta.quality = percentDone;
        if (i >= metadata.length - 1){
            finalQuality = percentDone
        }
    }

    const end = Date.now()
    console.log(end-start,'ms')
    return [finalQuality,metadata.length, Encode(metadata)]
}

const Decay = (data, amount, decayRate) => {
    const metadata2 = data;
    let metadata = Decode(metadata2)
    const lastIndex = metadata.length - 1
    const meta = metadata[lastIndex];
    const startDate = meta.created;
    const timeExtra = Math.ceil(86400 * decayRate);
    const newTime = (amount / 100) * timeExtra;
    console.log("Created Before:", meta.created)
    console.log(startDate - Math.floor(newTime), startDate,  Math.floor(newTime))
    meta.created = startDate - Math.floor(newTime);
    console.log("Created After:", meta.created)
    meta.quality -= amount;

    if (meta.quality < 0) { meta.quality = 0; }

    metadata[lastIndex] = meta

    const updatedMetadata = {
        count: lastIndex,
        data: Encode(metadata),
    }
    return updatedMetadata
}

exports('Encode', Encode)
exports('Decode', Decode)
exports('Convert', Convert)
exports('Decay', Decay)