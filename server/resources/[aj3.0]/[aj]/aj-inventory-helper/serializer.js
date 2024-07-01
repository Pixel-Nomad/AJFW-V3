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


        meta.quality = percentDone;
        if (i >= metadata.length - 1){
            finalQuality = percentDone
        }
    }

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
    meta.created = startDate - Math.floor(newTime);
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