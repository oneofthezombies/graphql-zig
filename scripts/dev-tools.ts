import { $ } from "bun";
import fs from "node:fs";

const REFERENCES_DIR = "references";
await $`mkdir -p ${REFERENCES_DIR}`;
if (!fs.existsSync(`${REFERENCES_DIR}/graphql-js`)) {
  await $`git -C ${REFERENCES_DIR} clone --depth=1 --branch=v16.10.0 https://github.com/graphql/graphql-js.git"`;
}
