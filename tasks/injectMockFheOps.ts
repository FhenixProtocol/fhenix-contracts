import chalk from 'chalk'
import { HardhatRuntimeEnvironment } from 'hardhat/types'
import { TASK_TEST } from 'hardhat/builtin-tasks/task-names'
import { HARDHAT_NETWORK_NAME } from 'hardhat/plugins'
import { task } from 'hardhat/config'

export const injectFhenixMocks = async (hre: HardhatRuntimeEnvironment) => {
	if (hre.network.name === HARDHAT_NETWORK_NAME) {
		const MockFheOpsArtifact = await hre.artifacts.readArtifact('MockFheOps')

		await hre.network.provider.send('hardhat_setCode', ['0x0000000000000000000000000000000000000080', MockFheOpsArtifact.deployedBytecode])

		console.log(chalk.bold(chalk.green('fhenix-hardhat-network - Using mocked FHE on Hardhat network')))
	}
}

task(TASK_TEST, 'Deploy fhenix mock contracts into test hardhat runner').setAction(async ({}, hre: HardhatRuntimeEnvironment, runSuper) => {
	await injectFhenixMocks(hre)
	return runSuper()
})
