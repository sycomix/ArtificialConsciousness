using Microsoft.VisualStudio.TestTools.UnitTesting;
using Moq;
using AC.BLL.Implementations.Node;
using AC.DAL.Repositories.Interfaces.Nodes;
using AC.DAL.EF;
using AC.BLL.Models.Nodes;
using AutoMapper;
using System.Threading.Tasks;
using AC.BLL.Common;
using AC.DAL.Common.Interfaces;
using System.Collections.Generic;
using System.Linq;

namespace AC.Tests
{
    [TestClass]
    public class NodeServiceTests
    {
        [TestMethod]
        public async Task DeleteAsync_NodeHasConnections_ReturnsFail()
        {
            var mockRepo = new Mock<INodeRepository>();
            var mockMapper = new Mock<IMapper>();

            var node = new DAL.EF.Node()
            {
                Id = 1,
                Name = "TestNode",
                ConnectionsFrom = new List<DAL.EF.Connection>() { new DAL.EF.Connection() },
                ConnectionsTo = new List<DAL.EF.Connection>()
            };

            mockRepo.Setup(r => r.GetByIdWithReferencAsync(1)).ReturnsAsync(node);

            // Setup the repository also to behave as an IDatabaseTransaction
            var mockDb = mockRepo.As<IDatabaseTransaction>();
            mockDb.Setup(x => x.SaveChangesAsync(It.IsAny<bool>())).ReturnsAsync(1);

            var service = new NodeService(mockRepo.Object, mockMapper.Object);

            var result = await service.DeleteAsync(1);

            Assert.IsFalse(result.Succeed);
        }

        [TestMethod]
        public async Task DeleteAsync_NodeHasNoConnections_CallsDeleteAndSucceeds()
        {
            var mockRepo = new Mock<INodeRepository>();
            var mockMapper = new Mock<IMapper>();

            var node = new DAL.EF.Node()
            {
                Id = 2,
                Name = "TestNode2",
                ConnectionsFrom = new List<DAL.EF.Connection>(),
                ConnectionsTo = new List<DAL.EF.Connection>()
            };

            mockRepo.Setup(r => r.GetByIdWithReferencAsync(2)).ReturnsAsync(node);
            mockRepo.Setup(r => r.DeleteAsync(2)).Returns(Task.CompletedTask);

            var mockDb = mockRepo.As<IDatabaseTransaction>();
            mockDb.Setup(x => x.SaveChangesAsync(It.IsAny<bool>())).ReturnsAsync(1);

            var service = new NodeService(mockRepo.Object, mockMapper.Object);

            var result = await service.DeleteAsync(2);

            Assert.IsTrue(result.Succeed);
            mockRepo.Verify(x => x.DeleteAsync(2), Times.Once);
        }
    }
}