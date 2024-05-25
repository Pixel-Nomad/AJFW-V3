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
        let percentDone = 100 - Math.ceil(((currentTime - startDate) / timeExtra) * 100);

        if (decayRate === 0) {
            percentDone = 100;
        }
        if (percentDone < 0) {
            percentDone = 0;
        }

        const finalPercent = meta.quality - (100 - percentDone);
        meta.quality = finalPercent < 0 ? 0 : finalPercent;
        if (i >= metadata.length - 1){
            finalQuality = finalPercent
        }
    }

    const end = Date.now()
    console.log(end-start,'ms')
    return [finalQuality,metadata.length, Encode(metadata)]
}

const Decay = (data) => {
    const metadata2 = data;
    let metadata = Decode(metadata2)
    metadata[metadata.length - 1].quality -= amount;
    metadata = {
        count: metadata.length - 1,
        data: Encode(metadata),
    }
    return metadata
}

exports('Encode', Encode)
exports('Decode', Decode)
exports('Convert', Convert)
exports('Decay', Decay)